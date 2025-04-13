set -ex
DENOM=ustars
CHAINID=stargaze
RLYKEY=stars12g0xe2ld0k5ws3h7lmxc39d4rpl3fyxp5qys69
LEDGER_ENABLED=false make install
starsd version --long
STARGAZE_HOME=/stargaze/starsd


# Setup stargaze
starsd init --chain-id $CHAINID $CHAINID --home $STARGAZE_HOME
sed -i 's#tcp://127.0.0.1:26657#tcp://0.0.0.0:26657#g' $STARGAZE_HOME/config/config.toml
sed -i "s/\"stake\"/\"$DENOM\"/g" $STARGAZE_HOME/config/genesis.json
sed -i 's/pruning = "syncable"/pruning = "nothing"/g' $STARGAZE_HOME/config/app.toml
sed -i 's/enable = false/enable = true/g' $STARGAZE_HOME/config/app.toml
sed -i 's/localhost:9090/0.0.0.0:9090/g' $STARGAZE_HOME/config/app.toml
sed -i 's/localhost:1317/0.0.0.0:1317/g' $STARGAZE_HOME/config/app.toml
sed -i -e 's/timeout_commit = "5s"/timeout_commit = "100ms"/g' $STARGAZE_HOME/config/config.toml
sed -i -e 's/timeout_propose = "3s"/timeout_propose = "100ms"/g' $STARGAZE_HOME/config/config.toml
# sed -i -e 's/\"allow_messages\":.*/\"allow_messages\": [\"\/cosmos.bank.v1beta1.MsgSend\", \"\/cosmos.staking.v1beta1.MsgDelegate\"]/g' ~/.starsd/config/genesis.json
starsd keys --keyring-backend test add validator --home $STARGAZE_HOME
cat $STARGAZE_HOME/config/app.toml
starsd genesis add-genesis-account $(starsd keys --keyring-backend test show validator -a --home $STARGAZE_HOME) 1000000000000$DENOM --home $STARGAZE_HOME
starsd genesis add-genesis-account $RLYKEY 1000000000000$DENOM --home $STARGAZE_HOME
starsd genesis add-genesis-account stars1y8tcah6r989vna00ag65xcqn6mpasjjdekwfhm 1000000000000$DENOM --home $STARGAZE_HOME
starsd genesis add-genesis-account stars103y4f6h80lc45nr8chuzr3fyzqywm9n0gnr394 200000000000000$DENOM --home $STARGAZE_HOME
starsd genesis gentx validator 900000000$DENOM --keyring-backend test --chain-id $CHAINID --home $STARGAZE_HOME
starsd genesis collect-gentxs --home $STARGAZE_HOME

starsd start --pruning nothing --home $STARGAZE_HOME --grpc.address 0.0.0.0:9090 --rpc.laddr tcp://0.0.0.0:26657 --skip-preferred-settings
