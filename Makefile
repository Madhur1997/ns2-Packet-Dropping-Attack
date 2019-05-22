run:
	 ns Node50.tcl 
	 ns Node55.tcl 
	 ns Node60.tcl 
	 ns Node65.tcl 
	 ns Node70.tcl 
	 ns Node75.tcl 
	 ns Node80.tcl
getTrace:
	 awk -v nodes=${num} -f Node${name}.awk Node${num}.tr  > Node${num}${name}.tr
clean :
	rm -rf *.nam *.tr *.xg

combine: 
		 awk -f combineFiles.awk Node50${name}.tr Node55${name}.tr Node60${name}.tr Node65${name}.tr Node70${name}.tr Node75${name}.tr Node80${name}.tr > ${name}.xg

plot:
		xgraph -geometry 500X500 -P -bg white -t ${name} -x number\ of\ nodes -y ${name}% ${name}.xg


#name: Number=>number of attacker nodes
	   #Accuracy=>Accuracy of predicting attacker nodes
	   #PacketSuccess=>Packet Success Ratio.