
/*
 * elftool.c - Utility to work with ELF object files.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/*
 * Arguments:
 * $1 = object file
 * $2 = command
 * $3 = argument ...
 * commands:
 * dumpsections
 * objectsizes
 * findsymbol=<symbol>
 * setdebugflag=<value>
 *
 * Environment variables:
 * VERBOSE
 */

#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <unistd.h>

#include "library.h"

/******************************************************************************
 * libelf - start                                                             *
 ******************************************************************************/

#include <elf.h>

/*
 * ar.h
 */

/* ar archive magic and its length */
#define ARMAG  "!<arch>\n"
#define SARMAG 8

struct ar_hdr {
        char ar_name[16];
        char ar_date[12];
        char ar_uid[6];
        char ar_gid[6];
        char ar_mode[8];
        char ar_size[10];
        char ar_fmag[2];
        };

/*
 * File types.
 */
typedef enum {
        ELF_K_NONE = 0,
        ELF_K_AR,
        ELF_K_COFF,
        ELF_K_ELF,
        ELF_K_SENTINEL
        } Elf_Kind;

typedef struct _Elf_Scn {
        /* section header */
        union {
                Elf64_Shdr u_shdr64;
                Elf32_Shdr u_shdr32;
                } s_uhdr;
        } Elf_Scn;

typedef struct _Elf_Data {
        void   *d_buf;
        size_t  d_size;
        } Elf_Data;

typedef struct _Elf {
        int           fd;                       /* file descriptor */
        Elf_Kind      kind;                     /* kind */
        size_t        idlen;                    /* identifier size */
        unsigned int  class;                    /* ELF class */
        uint8_t      *data;                     /* file/member data */
        size_t        base;                     /* base */
        unsigned int  encoding;                 /* ELF data encoding */
        unsigned int  version;                  /* ELF version */
        uint8_t      *ehdr;                     /* ELF header */
        off_t         phoff;
        off_t         shoff;
        size_t        shnum;
        size_t        shentsize;
        int           shstrndx;
        off_t         scn_shstrtab_offset;
        off_t         scn_strtab_offset;
        off_t         scn_symtab_offset;
        size_t        scn_symtab_size;
        off_t         scn_text_offset;
        uint64_t      scn_text_addr;
        } Elf;

enum {
        ELF_E_NOERROR,
        ELF_E_UNKNOWN_ERROR,
        ELF_E_UNIMPLEMENTED,
        ELF_E_ARGUMENT,
        ELF_E_IO,
        ELF_E_NOMEM,
        ELF_E_UNKNOWN_CLASS,
        ELF_E_NOSUCHSCN,
        ELF_E_SENTINEL
        };

/******************************************************************************
 * libelf - end                                                               *
 ******************************************************************************/

typedef struct {
        const char *input_filename;
        int         command;
        Elf        *pelf;
        bool        flag_verbose;       /* VERBOSE environment variable */
        const char *symbol_name;
        uint64_t    symbol_value;
        uint8_t     debug_flag_value;
        } Application_t;

#define COMMAND_NONE         0
#define COMMAND_DUMPSECTIONS 1
#define COMMAND_OBJECTSIZES  2
#define COMMAND_FINDSYMBOL   3
#define COMMAND_SETDEBUGFLAG 4

/******************************************************************************
 *                                                                            *
 ******************************************************************************/

static Application_t application;

#if 0

#define TAB_SIZE 8

/******************************************************************************
 * compute_tabs()                                                             *
 *                                                                            *
 ******************************************************************************/
static int
compute_tabs(const char *string, size_t maximum_string_length)
{
        int    ntabs;
        size_t string_length;

        string_length = strlen(string);

        if (string_length < maximum_string_length)
        {
                ntabs = 0;
                while (string_length <= maximum_string_length)
                {
                        string_length = ((string_length + TAB_SIZE) / TAB_SIZE) * TAB_SIZE;
                        ++ntabs;
                }
        }
        else
        {
                ntabs = 1;
        }

        return ntabs;
}

/******************************************************************************
 * fprint_tabstospaces()                                                      *
 *                                                                            *
 ******************************************************************************/
static void
fprint_tabstospaces(FILE *fp, const char *input_string)
{
        char output_string[1024];
        int  idx1;
        int  idx2;
        char c;

        idx1 = 0;
        idx2 = 0;
        do
        {
                c = input_string[idx1];
                if (c == '\t')
                {
                        int nspaces;
                        int idx3;
                        nspaces = TAB_SIZE - (idx2 % TAB_SIZE);
                        if (nspaces == 0)
                        {
                                nspaces = TAB_SIZE;
                        }
                        for (idx3 = 0; idx3 < nspaces; ++idx3)
                        {
                                output_string[idx2] = ' ';
                                ++idx2;
                        }
                }
                else
                {
                        output_string[idx2] = c;
                        ++idx2;
                }
                ++idx1;
        } while (c != '\0');

        fprintf(fp, output_string);
}

#endif

/******************************************************************************
 * data_read()                                                                *
 *                                                                            *
 ******************************************************************************/
static int
data_read(int fd, void *buffer, size_t length)
{
        size_t datacount;
        size_t n;

        datacount = 0;
        while (datacount < length)
        {
                n = read(fd, (void *)((uint8_t *)buffer + datacount), length - datacount);
                if (n == 0)
                {
                        /* no data available */
                        return -1;
                }
                else if (n != (size_t)-1)
                {
                        /* read ok, continue */
                        datacount += n;
                }
                else if (errno != EAGAIN && errno != EINTR)
                {
                        /* error */
                        return -1;
                }
        }

        return 0;
}

/******************************************************************************
 * elf_read()                                                                 *
 *                                                                            *
 ******************************************************************************/
static void *
elf_read(Elf *pelf, void *buffer, off_t offset, size_t length)
{
        if (length != 0)
        {
                void *t_buffer;
                offset += pelf->base;
                if (lseek(pelf->fd, offset, SEEK_SET) != offset)
                {
                        //seterror(ELF_E_IO);
                }
                else if ((t_buffer = buffer) == NULL && (t_buffer = lib_malloc(length)) == NULL)
                {
                        //seterror(ELF_E_NOMEM);
                }
                else if (data_read(pelf->fd, t_buffer, length) < 0)
                {
                        //seterror(ELF_E_IO);
                        if (t_buffer != buffer)
                        {
                                lib_free((void *)t_buffer);
                                t_buffer = NULL;
                        }
                }
                else
                {
                        return t_buffer;
                }
        }

        return NULL;
}

/******************************************************************************
 * elf_begin()                                                                *
 *                                                                            *
 ******************************************************************************/
static Elf *
elf_begin(int fd)
{
        Elf    *pelf;
        off_t   fd_offset;
        size_t  size;

        fd_offset = lseek(fd, (off_t)0, SEEK_END);
        if (fd_offset == (off_t)-1)
        {
                //seterror(ELF_E_IO);
                return NULL;
        }
        size = fd_offset;

        pelf = (Elf *)lib_malloc(sizeof(Elf));
        if (pelf == NULL)
        {
                //seterror(ELF_E_NOMEM);
                return NULL;
        }
        pelf->fd = fd;
        pelf->base = 0;

        pelf->data = elf_read(pelf, NULL, 0, size);
        if (pelf->data == NULL)
        {
                lib_free((void *)pelf);
                pelf = NULL;
                return NULL;
        }
        pelf->ehdr = pelf->data;

        /*
         * Check ELF.
         */
        pelf->idlen = size;
        if (size >= EI_NIDENT && memcmp(pelf->data, ELFMAG, SELFMAG) == 0)
        {
                pelf->kind = ELF_K_ELF;
                pelf->idlen = EI_NIDENT;
                pelf->class = pelf->data[EI_CLASS];
                pelf->encoding = pelf->data[EI_DATA];
                pelf->version = pelf->data[EI_VERSION];
        }
        //else if (size >= SARMAG && memcmp(pelf->data, ARMAG, SARMAG) == 0)
        //{
        //        _elf_init_ar(elf);
        //}
        else
        {
                lib_free((void *)(pelf->data));
                pelf->data = NULL;
                lib_free((void *)pelf);
                pelf = NULL;
        }

        return pelf;
}

/******************************************************************************
 * elf_end()                                                                  *
 *                                                                            *
 ******************************************************************************/
static int
elf_end(Elf *pelf)
{
        if (pelf != NULL)
        {
                if (pelf->data != NULL)
                {
                        lib_free((void *)pelf->data);
                        pelf->data = NULL;
                }
                lib_free((void *)pelf);
                pelf = NULL;
        }

        return 0;
}

/******************************************************************************
 * elf_analyze()                                                              *
 *                                                                            *
 ******************************************************************************/
static void
elf_analyze(Elf *pelf)
{
        int         idx;
        off_t       name;
        off_t       offset;
        size_t      size;
        uint64_t    addr;
        const char *scn_name;

        /*
         * Start of program header table / section header table.
         */
        if (pelf->class == ELFCLASS32)
        {
                pelf->phoff               = ((Elf32_Ehdr *)pelf->ehdr)->e_phoff;
                pelf->shoff               = ((Elf32_Ehdr *)pelf->ehdr)->e_shoff;
                pelf->shnum               = ((Elf32_Ehdr *)pelf->ehdr)->e_shnum;
                pelf->shentsize           = ((Elf32_Ehdr *)pelf->ehdr)->e_shentsize;
                pelf->shstrndx            = ((Elf32_Ehdr *)pelf->ehdr)->e_shstrndx;
                pelf->scn_shstrtab_offset = ((Elf32_Shdr *)(pelf->data + pelf->shoff + pelf->shstrndx * pelf->shentsize))->sh_offset;
        }
        else if (pelf->class == ELFCLASS64)
        {
                pelf->phoff               = ((Elf64_Ehdr *)pelf->ehdr)->e_phoff;
                pelf->shoff               = ((Elf64_Ehdr *)pelf->ehdr)->e_shoff;
                pelf->shnum               = ((Elf64_Ehdr *)pelf->ehdr)->e_shnum;
                pelf->shentsize           = ((Elf64_Ehdr *)pelf->ehdr)->e_shentsize;
                pelf->shstrndx            = ((Elf64_Ehdr *)pelf->ehdr)->e_shstrndx;
                pelf->scn_shstrtab_offset = ((Elf64_Shdr *)(pelf->data + pelf->shoff + pelf->shstrndx * pelf->shentsize))->sh_offset;
        }
        for (idx = 1; idx < (int)pelf->shnum; idx++)
        {
                if (pelf->class == ELFCLASS32)
                {
                        name   = ((Elf32_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize))->sh_name;
                        offset = ((Elf32_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize))->sh_offset;
                        size   = ((Elf32_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize))->sh_size;
                        addr   = ((Elf32_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize))->sh_addr;
                }
                else if (pelf->class == ELFCLASS64)
                {
                        name   = ((Elf64_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize))->sh_name;
                        offset = ((Elf64_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize))->sh_offset;
                        size   = ((Elf64_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize))->sh_size;
                        addr   = ((Elf64_Shdr *)(pelf->data + pelf->shoff + idx * pelf->shentsize))->sh_addr;
                }
                /* get section name */
                scn_name = (const char *)(pelf->data + pelf->scn_shstrtab_offset + name);
                if      (strcmp(scn_name, ".strtab") == 0)
                {
                        pelf->scn_strtab_offset = offset;
                }
                else if (strcmp(scn_name, ".symtab") == 0)
                {
                        pelf->scn_symtab_offset = offset;
                        pelf->scn_symtab_size   = size;
                }
                else if (strcmp(scn_name, ".text") == 0)
                {
                        pelf->scn_text_offset = offset;
                        pelf->scn_text_addr   = addr;
                }
        }
}

/******************************************************************************
 * elf_find_symbol()                                                          *
 *                                                                            *
 ******************************************************************************/
static int
elf_find_symbol(Elf *pelf, const char *symbol, uint64_t *pvalue)
{
        int         nsymbol;
        int         idx;
        off_t       name;
        size_t      shndx;
        size_t      value;
        size_t      size;
        const char *symbol_name;

        if (pelf->class == ELFCLASS32)
        {
                nsymbol = pelf->scn_symtab_size / sizeof(Elf32_Sym);
        }
        else if (pelf->class == ELFCLASS64)
        {
                nsymbol = pelf->scn_symtab_size / sizeof(Elf64_Sym);
        }
        for (idx = 1; idx < nsymbol; idx++)
        {
                if (pelf->class == ELFCLASS32)
                {
                        name  = ((Elf32_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf32_Sym)))->st_name;
                        shndx = ((Elf32_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf32_Sym)))->st_shndx;
                        value = ((Elf32_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf32_Sym)))->st_value;
                        size  = ((Elf32_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf32_Sym)))->st_size;
                }
                else if (pelf->class == ELFCLASS64)
                {
                        name  = ((Elf64_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf64_Sym)))->st_name;
                        shndx = ((Elf64_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf64_Sym)))->st_shndx;
                        value = ((Elf64_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf64_Sym)))->st_value;
                        size  = ((Elf64_Sym *)(pelf->data + pelf->scn_symtab_offset + idx * sizeof(Elf64_Sym)))->st_size;
                }
                (void)shndx;
                (void)size;
                symbol_name = (const char *)(pelf->data + pelf->scn_strtab_offset + name);
                if (strcmp(symbol_name, symbol) == 0)
                {
                        *pvalue = value;
                        return 0;
                }
        }

        return -1;
}

/******************************************************************************
 * command_findsymbol()                                                       *
 *                                                                            *
 ******************************************************************************/
static int
command_findsymbol(void)
{
        elf_analyze(application.pelf);

        if (elf_find_symbol(application.pelf, application.symbol_name, &application.symbol_value) < 0)
        {
                return -1;
        }

        return 0;
}

/******************************************************************************
 * command_setdebugflag()                                                     *
 *                                                                            *
 ******************************************************************************/
static int
command_setdebugflag(void)
{
        off_t offset;

        elf_analyze(application.pelf);

        if (elf_find_symbol(application.pelf, "_debug_flag", &application.symbol_value) < 0)
        {
                return -1;
        }

        offset = application.pelf->scn_text_offset + (application.symbol_value - application.pelf->scn_text_addr);
        lseek(application.pelf->fd, offset, SEEK_SET);
        write(application.pelf->fd, (void *)&application.debug_flag_value, 1);

        return 0;
}

/******************************************************************************
 * process_arguments()                                                        *
 *                                                                            *
 ******************************************************************************/
static int
process_arguments(int argc, char **argv, Application_t *p, const char **error_message)
{
        bool error_flag;
        int  number_of_arguments;
        bool plain_token_flag;
        int  idx;

        error_flag = false;
        number_of_arguments = argc;
        plain_token_flag = false;
        idx = 0;

        if (number_of_arguments > 0)
        {
                --number_of_arguments;
                ++idx;
        }

        while (!error_flag && number_of_arguments > 0)
        {
                --number_of_arguments;
                if (argv[idx][0] == '-')
                {
                        char c;
                        const char *dumpsections_option = "dumpsections";
                        const char *objectsizes_option = "objectsizes";
                        const char *findsymbol_option = "findsymbol=";
                        const char *setdebugflag_option = "setdebugflag=";
                        size_t findsymbol_optionlength = strlen(findsymbol_option);
                        size_t setdebugflag_optionlength = strlen(setdebugflag_option);
                        if (strlen(argv[idx]) != 2)
                        {
                                error_flag = true;
                                if (error_message != NULL)
                                {
                                        *error_message = "bad switch";
                                }
                        }
                        c = argv[idx][1];
                        switch (c)
                        {
                                case 'c':
                                        --number_of_arguments;
                                        ++idx;
                                        if (strcmp(argv[idx], dumpsections_option) == 0)
                                        {
                                                p->command = COMMAND_DUMPSECTIONS;
                                        }
                                        else if (strcmp(argv[idx], objectsizes_option) == 0)
                                        {
                                                p->command = COMMAND_OBJECTSIZES;
                                        }
                                        else if (strncmp(argv[idx], findsymbol_option, findsymbol_optionlength) == 0)
                                        {
                                                p->command = COMMAND_FINDSYMBOL;
                                                p->symbol_name = argv[idx] + findsymbol_optionlength;
                                        }
                                        else if (strncmp(argv[idx], setdebugflag_option, setdebugflag_optionlength) == 0)
                                        {
                                                p->command = COMMAND_SETDEBUGFLAG;
                                                p->debug_flag_value = (uint8_t)strtoul(argv[idx] + setdebugflag_optionlength, NULL, 16);
                                        }
                                        else
                                        {
                                                error_flag = true;
                                                if (error_message != NULL)
                                                {
                                                        *error_message = "unknown command";
                                                }
                                        }
                                        break;
                                default:
                                        error_flag = true;
                                        if (error_message != NULL)
                                        {
                                                *error_message = "unknown switch";
                                        }
                                        break;
                        }
                }
                else
                {
                        if (plain_token_flag == false)
                        {
                                plain_token_flag = true;
                                p->input_filename = argv[idx];
                        }
                        else
                        {
                                error_flag = true;
                                if (error_message != NULL)
                                {
                                        *error_message = "more than one filename specified";
                                }
                        }
                }
                if (!error_flag)
                {
                        ++idx;
                }
        }

        return error_flag ? -1 : 0;
}

/******************************************************************************
 * main()                                                                     *
 *                                                                            *
 * Main loop.                                                                 *
 ******************************************************************************/
int
main(int argc, char **argv)
{
        int         exit_status;
        char        program_name[PATH_MAX + 1];
        int         fd;
        char       *verbose_string;
        const char *process_arguments_error_message;

        exit_status = EXIT_FAILURE;
        fd = -1;

        application.input_filename = NULL;
        application.command        = COMMAND_NONE;
        application.pelf           = NULL;
        application.flag_verbose   = false;

        /*
         * Extract the program name.
         */
        strcpy(program_name, file_basename_simple(argv[0]));

        /*
         * Initialize logging.
         */
        log_init(program_name, NULL, NULL);
        log_mode_set(LOG_STDOUT | LOG_STDERR);

        /*
         * Verbose mode.
         */
        verbose_string = (char *)env_get("VERBOSE");
        if (verbose_string != NULL)
        {
                if (strcmp(verbose_string, "Y") == 0)
                {
                        application.flag_verbose = true;
                }
                lib_free(verbose_string);
                verbose_string = NULL;
        }

        /*
         * Argument processing.
         */
        if (process_arguments(argc, argv, &application, &process_arguments_error_message) < 0)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: %s.", process_arguments_error_message);
                goto main_exit;
        }
        if (application.input_filename == NULL)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: no input file.");
                goto main_exit;
        }
        if (application.command == COMMAND_NONE)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: no command supplied.");
                goto main_exit;
        }

        /*
         * Open input file.
         */
#if __START_IF_SELECTION__
#elif defined(_WIN32)
        fd = open(application.input_filename, O_RDWR | O_BINARY);
#elif defined(__APPLE__) || defined(__linux__)
        fd = open(application.input_filename, O_RDWR);
#endif
        if (fd < 0)
        {
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: open(): %s: %s.", application.input_filename, strerror(errno));
                goto main_exit;
        }

        /*
         * Build the ELF descriptor.
         */
        application.pelf = elf_begin(fd);
        if (application.pelf == NULL)
        {
                //log_printf(LOG_STDERR | LOG_FILE, "*** Error: elf_begin(): %s.", elf_errmsg(-1));
                log_printf(LOG_STDERR | LOG_FILE, "*** Error: elf_begin().");
                goto main_exit;
        }

        /*
         * Process command.
         */
        switch (application.command)
        {
//                case COMMAND_DUMPSECTIONS:
//                        if (command_dumpsections() < 0)
//                        {
//                                goto main_exit;
//                        }
//                        break;
//                case COMMAND_OBJECTSIZES:
//                        if (command_objectsizes() < 0)
//                        {
//                                goto main_exit;
//                        }
//                        break;
                case COMMAND_FINDSYMBOL:
                        if (command_findsymbol() < 0)
                        {
                                goto main_exit;
                        }
                        switch (application.pelf->class)
                        {
                                case ELFCLASS32:
                                        fprintf(
                                                stdout,
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                                "0x%08I64X\n",
#elif defined(__APPLE__)
                                                "0x%08X\n",
#else
                                                "0x%08X\n",
#endif
                                                (uint32_t)application.symbol_value
                                                );
                                        break;
                                case ELFCLASS64:
                                        fprintf(
                                                stdout,
#if __START_IF_SELECTION__
#elif defined(_WIN32)
                                                "0x%016I64X\n",
#elif defined(__APPLE__)
                                                "0x%016llX\n",
#else
                                                "0x%016lX\n",
#endif
                                                application.symbol_value
                                                );
                                default:
                                        break;
                        }
                        break;
                case COMMAND_SETDEBUGFLAG:
                        if (command_setdebugflag() < 0)
                        {
                                goto main_exit;
                        }
                        break;
                default:
                        /* __DNO__ */
                        break;
        }

        exit_status = EXIT_SUCCESS;

main_exit:

        if (application.pelf != NULL)
        {
                elf_end(application.pelf);
                application.pelf = NULL;
        }

        if (fd >= 0)
        {
                close(fd);
        }

        /*
         * Close logging.
         */
        log_close();

        exit(exit_status);
}
