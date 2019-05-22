set ns [new Simulator]


set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(rp) AODV ;# routing protocol
set val(x) 900 ;# X dimension of topography
set val(y) 900 ;# Y dimension of topography
set val(stop) 10.0 ;# time of simulation end

# set up topography object
set numNodes 65
create-god $numNodes
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

#Nam File Creation nam – network animator
set namfile [open Node$numNodes.nam w]

#Tracing all the events and cofiguration
$ns namtrace-all-wireless $namfile $val(x) $val(y)

#Trace File creation
set tracefile [open Node$numNodes.tr w]

#Tracing all the events and cofiguration
$ns trace-all $tracefile


# configure the nodes
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON


# Node Creation

for {set i 0} {$i < $numNodes} {incr i } {

set node_($i) [$ns node]
set udp($i) [new Agent/UDP]
set cbr($i) [new Application/Traffic/CBR]
$node_($i) color black

}
for {set i 0} {$i < $numNodes} {incr i} {

$node_($i) set X_ [expr rand()*$val(x)]
$node_($i) set Y_ [expr rand()*$val(y)]
$node_($i) set Z_ 0

}

# Label and coloring

for {set i 0} {$i < $numNodes} {incr i} {

$ns at 0.1 "$node_($i) color blue"
$ns at 0.1 "$node_($i) label Node$i"

}
#Size of the node

for {set i 0} {$i < $numNodes} {incr i} {

$ns initial_node_pos $node_($i) 30

}
#******************************Defining Communication Between node0 and all nodes ****************************8

set null [new Agent/Null]
$ns attach-agent $node_(0) $null

for {set i 1} {$i < $numNodes} {incr i} {

$ns attach-agent $node_($i) $udp($i)
$cbr($i) attach-agent $udp($i)
$ns connect $udp($i) $null
$cbr($i) set packetSize_ 1024
$cbr($i) set interval_ 0.1
}

for {set i 1} {$i < $numNodes} {incr i} {
$ns at $i "$cbr($i) start"
}

#Stopping
$ns at 10.01 "puts \"end simulation\" ; $ns halt"

#exec awk -f Node50.awk Node50.tr > TrustEntropy50.tr &
#exec xgraph -geometry 500X500 -P -bg white -t Packet_Delivery_Ratio -x time(s) -y Packet_Delivery_Ratio(%) pdr.xg &

#Starting scheduler
$ns run