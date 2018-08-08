void miladitoshamsi(unsigned char dsh,unsigned char msh,unsigned char ysh){
    unsigned char miladimonth[12]={31,28,31,30,31,30,31,31,30,31,30,31};
    unsigned char shamsimonth[12]={31,31,31,31,31,31,30,30,30,30,30,29};
    unsigned char i=0;
    int sumdaymiladi=0,sumdayshamsi=0;
    //sal=0,rooz=0;mah=1;
	for (i=0; i<msh-1;i++){
		sumdayshamsi+=shamsimonth[i];
	}
	sumdayshamsi+=dsh;
    if(sumdayshamsi<287){
        year=ysh+621;
		sumdaymiladi=sumdayshamsi+79;
        
    }
	if(sumdayshamsi>287){
        year=ysh+622;
        sumdaymiladi=sumdayshamsi-278;
    }
    if(sumdayshamsi==287){
		if (((((ysh+621)%4)==0)&&(((ysh+621)%100)!=0))||((((ysh+621)%100)==0)&&(((ysh+621)%400)==0))){
			year=ysh+621;
			sumdaymiladi=sumdayshamsi+79;
		}else{
			year=ysh+622;
			sumdaymiladi=sumdayshamsi-286;
		}
	}
	if ((((year%4)==0)&&((year%100)!=0))||(((year%100)==0)&&((year%400)==0))){
		milaimonth[1]=29;
	}else{
		milaimonth[1]=28;
	}
	i=0;
	month=1;
	while((sumdaymiladi>31) || () || () || ()){            
        sumdaymiladi-=miladimonth[i];
        month++;
        i++;
    }
	
	if ((((year%4)==0)&&((year%100)!=0))||(((year%100)==0)&&((year%400)==0))){
		if (i==1 && sumdaymiladi>29){
			month++;
			sumdaymiladi-=miladimonth[1];
		}
	}else{
		if ((i==1 && sumdaymiladi>28)((i==3 || i==5 || i==8 || i==10)&&sumdaymiladi>30)){
			if(i==1){
				month++;
				sumdaymiladi-=miladimonth[1];
			}
			if(i==3 || i==5 || i==8 || i=10){
				month++;
				sumdaymiladi-=miladimonth[3];
			}
		}
	}
	day=sumdaymiladi;
	
}

if (((((year-1)%4)==0)&&(((2000+ym-1)%100)!=0))||((((2000+ym-1)%100)==0)&&(((2000+ym-1)%400)==0)))