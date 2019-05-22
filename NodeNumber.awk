BEGIN{
    for (i = 0; i < nodes; ++i) 
    {
        dropped["_"i"_"] = 0.0;
        forwarded["_"i"_"] = 0.0;
        attacker[i] = 0
        #printf "%d", i
    }
    for(i=0;i<0.2*nodes;i++){
        attacker[3*i+2] = 1
    }
    thresholdValue = 0.73;
}

{
    #node = $3
  if($1 == "D") {
       dropped[$3] = dropped[$3] + 1;
       #node = $3;
  }
  if($1 == "f"){
      forwarded[$3] = forwarded[$3] + 1;
  }

}

END{
    #printf "%s", node
    count = 0;
    for (i = 0; i < nodes; ++i){
        n = 7
        #printf "%s", node
        trust = (forwarded["_"i"_"]+n)/(forwarded["_"i"_"]+n+dropped["_"i"_"]+1)
        #printf "%f ",trust
        val2 = log(trust)/log(2.0)
        #printf("%f ", val2)
        val3 = log(1-trust)/log(2.0)
        #printf("%f ", val3)
        M = -1.0*trust*val2 - (1.0-trust)*val3;
        #printf("%f ", M)
        if (trust >=0.5 && trust<=1)
            trustEntropy = 1-M;
        else if (trust<=0.5&&trust>=0)
            trustEntropy = M-1;
	#printf("%f ",trustEntropy)
        trustEntropy = (trustEntropy + 1)/2.0
	#printf("%f ", trustEntropy)
        if(trustEntropy<thresholdValue){
	#printf("%d ", i)
            if(attacker[i]==1) {
                count++;
            }
        }    
	#printf("\n");  
   }
   accuracy = (count/(0.2*nodes))*100;
   printf "%d %f\n", nodes, count
}
