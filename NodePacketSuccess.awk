BEGIN{
 countTotal = 0.0;
 countSuccess = 0.0;
 #printf("%d", nodes)
}

{
 countTotal=countTotal+1;
 if($1=="r"&&$3=="_"0"_")
    countSuccess= countSuccess+1;
}

END{
    #printf "%s", node
   #printf("%f", countTotal)
    ratio = countSuccess/countTotal
	#printf("\n");  
   printf "%d %f\n", nodes, ratio
}
