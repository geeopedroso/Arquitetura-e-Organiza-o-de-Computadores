//Decodificador em c
// alunos:  Geovani Pedroso
//			Vinicius Pétris 
//			Lucas Gabriel da Silva



#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#define _GNU_SOURCE

// Campos do formato de instrução.
// opcode  := ir(31 downto 26)
// rs      := ir(25 downto 21);
// rt      := ir(20 downto 16);
// rd      := ir(15 downto 11);
// shamt   := ir(10 downto  6);
// imm     := ir(15 downto  0);
// address := ir(25 downto  0);

unsigned int mascaraOpCode = 0xFC000000;
unsigned int mascaraRs =     0x03E00000;
unsigned int mascaraRt =     0x001F0000;
unsigned int mascaraRd =     0x0000F800;
unsigned int mascaraShamt =  0x000007C0;
unsigned int mascaraFunct =  0x0000003F;
int mascaraImmediate =  0x0000FFFF;
unsigned int mascaraAddress =   0x03FFFFFF;

char * registers[32] = {"$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3", "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"};



unsigned int getOpCode(unsigned int ir) {
	printf("opcode: %d\n ", (ir & mascaraOpCode) >> 26);
	return (ir & mascaraOpCode) >> 26;
}

unsigned int getRs(unsigned int ir) {
	return (ir & mascaraRs) >> 21;
}

unsigned int getRt(unsigned int ir) {
	return (ir & mascaraRt) >> 16;
}

unsigned int getRd(unsigned int ir) {
	return (ir & mascaraRd) >> 11;
}

unsigned int getShamt(unsigned int ir) {
	return (ir & mascaraShamt) >> 6;
}

unsigned int getFunct(unsigned int ir) {
	return (ir & mascaraFunct);
}

int getImmediate(int ir) {
	return (ir & mascaraImmediate);
}

unsigned int getAddress(unsigned int ir) {
	return (ir & mascaraAddress);
}

void bin_prnt_byte(int x)
{
   int n;
   for(n=0; n<32; n++)
   {
      if((x & 0x80) !=0)
      {
         printf("1");
      }
      else
      {
         printf("0");
      }
      if (n==3)
      {
         printf(" ");
      }
      x = x<<1;
   }
}

// Converte um char * representando um binário para inteiro.
int fromBinary(char *s) {
  int teste = (int) strtol(s, 0, 2);
  bin_prnt_byte(teste);
  printf("\n");

  return teste;
}


// Decodifica uma instrução.
void decodificar(int ir) {
    switch (getOpCode(ir)) {
        case 0 : // 000000
                switch (getFunct(ir)) {
                    case 0 :  // 000000 -> sll.
                    			printf("sll ");
                    			printf("%s, ", registers[getRd(ir)]);
                    			printf("%s, ", registers[getRt(ir)]);
                    			printf("%d\n", getShamt(ir));
                    			break;
					case 2 :  // 000010 -> srl.
                    			printf("srl ");
                    			printf("%s, ", registers[getRd(ir)]);
                    			printf("%s, ", registers[getRt(ir)]);
                    			printf("%d\n",getShamt(ir));
                    			break;
					case 8 :  // 001000 -> jr.
								printf("jr ");
                                printf("%s\n", registers[getRs(ir)]);
                                break;
					case 32 : // 100000 -> add.
                                printf("add ");
                                printf("%s, ", registers[getRd(ir)]);
                                printf("%s, ", registers[getRs(ir)]);
                                printf("%s\n", registers[getRt(ir)]);
                                break;
                    case 33 : // 100001 -> addu.
                    			printf("addu ");
                                printf("%s, ", registers[getRd(ir)]);
                                printf("%s, ", registers[getRs(ir)]);
                                printf("%s\n", registers[getRt(ir)]);
                                break;
					case 34 : // 100010 -> sub.
                                printf("sub ");
                                printf("%s, ", registers[getRd(ir)]);
                                printf("%s, ", registers[getRs(ir)]);
                                printf("%s\n", registers[getRt(ir)]);
                                break;
                    case 35 : // 100010 -> subu.
                                printf("subu ");
                                printf("%s, ", registers[getRd(ir)]);
                                printf("%s, ", registers[getRs(ir)]);
                                printf("%s\n", registers[getRt(ir)]);
                                break;
					case 36 : // 100100 -> and.
                    			printf("and ");
                    			printf("%s, ", registers[getRd(ir)]);
                    			printf("%s, ", registers[getRs(ir)]);
                    			printf("%s\n", registers[getRt(ir)]);
                    			break;
                    case 37 : // 100101 -> or.
                    			printf("or ");
                    			printf("%s, ", registers[getRd(ir)]);
                    			printf("%s, ", registers[getRs(ir)]);
                    			printf("%s\n", registers[getRt(ir)]);
                    			break;
					case 39 : // 100111 -> nor.
                    			printf("nor ");
                                printf("%s, ", registers[getRd(ir)]);
                                printf("%s, ", registers[getRs(ir)]);
                                printf("%s\n", registers[getRt(ir)]);
                                break;
                    case 42 : // 101010 -> slt.
                    			printf("slt ");
                    			printf("%s, ", registers[getRd(ir)]);
                    			printf("%s, ", registers[getRs(ir)]);
                    			printf("%s\n", registers[getRt(ir)]);
                    			break;
                    case 43 : // 101011 -> sltu.
                    			printf("sltu ");
                    			printf("%s, ", registers[getRd(ir)]);
                    			printf("%s, ", registers[getRs(ir)]);
                    			printf("%s\n", registers[getRt(ir)]);
                    			break;
					case 12 : //00 1100
								printf("syscall \n");
								break;


                }
                break;
        case 2 : // 000010 -> j.
        			printf("j ");
        			printf("%d\n", getAddress(ir));
        			break;
		case 3 :  // 000011 -> jal.
					printf("jal ");
        			printf("%d\n", getAddress(ir));
        			break;
		case 4 : // 000100 -> beq.
        			printf("beq ");
                   	printf("%s, ", registers[getRs(ir)]);
                    printf("%s, ", registers[getRt(ir)]);
                    printf("%d\n", getImmediate(ir));
                   	break;
        case 5 : // 000101 -> bne.
        			printf("bne ");
                   	printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
        case 8 : // 001000 -> addi.
        			printf("addi ");
                   	printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
        case 9 : // 001001 -> addiu.
        			printf("addiu ");
                   	printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
       	case 10 : // 001010 -> slti.
       				printf("slti ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
        case 11 : // 001011 -> sltiu.
        			printf("sltiu ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
		case 12 : // 001100 -> andi.
	   				printf("andi ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
       	case 13 : // 001101 -> ori
       				printf("ori ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
		case 15 : // 001111 -> lui.
       				printf("lui ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
        case 35 : // 100011 -> lw.
        			printf("lw ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
		case 36 : // 100100 -> lbu.
       				printf("lbu ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%d(%s)\n", getImmediate(ir), registers[getRs(ir)]);
                   	break;
    	case 37 : // 100101 -> lhu.
    				printf("lhu ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%d(%s)\n", getImmediate(ir), registers[getRs(ir)]);
                   	break;
        case 40 : // 101000 -> sb.
        			printf("sb ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%d(%s)\n", getImmediate(ir), registers[getRs(ir)]);
                   	break;
        case 41 : // 101001 -> sh.
        			printf("sh ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%d(%s)\n", getImmediate(ir), registers[getRs(ir)]);
                   	break;
        case 43 : // 101011 -> sw.
        			printf("sw ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%d(%s)\n", getImmediate(ir), registers[getRs(ir)]);
                   	break;
	    case 48 : // 110000 -> ll.
        			printf("ll ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%s, ", registers[getRs(ir)]);
                   	printf("%d\n", getImmediate(ir));
                   	break;
        case 56 : // 111000 -> sc.
        			printf("sc ");
					printf("%s, ", registers[getRt(ir)]);
                   	printf("%d(%s)\n", getImmediate(ir), registers[getRs(ir)]);
                   	break;
       default : // outros casos.
                  printf("Instrucao nao implementada. \n");

    }
}

int main(int argc,char *argv[]){
   int i;
   int ir;



   FILE *arquivo= fopen("binario.b", "r");
   size_t len= 32;  // tamanho da linha.
   char *linha= malloc(len);

   if (!arquivo) {
        perror(argv[1]);
        exit(1);
   }

   while (getline(&linha, &len, arquivo) > 0){
        printf("Linha: %s", linha);
        ir = fromBinary(linha);
        printf("Inteiro: %d\n", ir);
        decodificar(ir);
   }

   if (linha)
    free(linha);

   fclose(arquivo);
   return 0;
}
