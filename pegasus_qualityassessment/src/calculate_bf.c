#include<stdio.h>
#include<stdlib.h>
#include<string.h>

char MSA[370000][10000];

float equal(char Seq1[10000],char Seq2[10000])
{
    float eq=0.0;
    float len=0.0;
    int i,j;

    for(i=0;i<strlen(Seq1);i++)
    {
        if(Seq1[i]!='-' && Seq1[i]!='.')
        {
            len+=1.0;
            if(Seq1[i]==Seq2[i])
            {
                eq+=1.0;
            }
        }
    }
    if (eq/len >= 0.9)
        return 1.0;
    else
        return 0.0;

}


int main(int argc, char *argv[])
{
    char c;
    FILE *input;
    int i,j,N;    
    float Beff=0.0,m;
    input = fopen(argv[1],"r");
    for(i=0;fscanf(input,"%s",MSA[i])!=EOF;i++);
    N=i;

    for(i=0;i<N;i++)
    {
        m=0.0;
        for(j=0;j<N;j++)
            m+=equal(MSA[i],MSA[j]);
        Beff+=1.0/m;
    }
    printf("%s %.0f",argv[1],Beff);
    return 0;
}
