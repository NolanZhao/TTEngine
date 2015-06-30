
echo call $0 ...
CodeGenerator=$BUILD_HOME_DIR/../script/codeGenerator/CodeGenerator.py
function genheader()
{
	rpcfile=$BUILD_HOME_DIR/protocol/$1.rpc
	outfile=$BUILD_HOME_DIR/include/Protocol/rpc_$1.h
	if [ "$3" != "" ] 
	then
		outfile=$BUILD_HOME_DIR/include/Protocol/rpc_$1$3.h
	fi
	#rm -f $outfile
	cmdline="python \"$CodeGenerator\" \"$2\" \"$rpcfile\" \"$outfile\" "
	echo $cmdline
	eval $cmdline
}

#add module here
StdServerS="StockClientTrader TradingMonitorService ClientTrader TTServiceCommon WebService StockCommon"
StdStockClientS="StockTrader"
StdClientS="Trader Broker"

for StdServer in $StdServerS
do
	genheader $StdServer StdServer
done


for StdClient in $StdClientS
do
	genheader $StdClient StdClient
done

for StdStockClient in $StdStockClientS
do
	genheader $StdStockClient StdStockClient
done

genheader TradingMonitorService StdClient Client

