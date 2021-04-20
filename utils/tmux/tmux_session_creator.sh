#!/bin/sh
#
# tmux_session_creator.sh - Automating the creation of a tmux session
# 
#Site       :http://renantmagalhaes.com
#Autor      :Renan Toesqui Magalhães <renantmagalhaes@gmail.com>
#
# ---------------------------------------------------------------
#   
#	Create a work environment using tmux.	
#
# 
# --------------------------------------------------------------
#
# Changelog
#
#   V1.0 2016-03, RTM:
#       - Inicial Release
#       - Logic formation
#
#
#   V1.1 2018-07, RTM:
#       - Change all to vars
#              
#
#
#   TODO
#
#  
#
#RTM

#Session name
SESSION=""

#Key folder location
KEYFOLDER=""

#Key file
KEYFILE1=""

#Servers 
#example user@10.0.0.1
SERVER1=""
SERVER2=""
SERVER3=""
SERVER4=""
SERVER5=""

#Create first window :0 
tmux start-server
tmux -2 new-session -d -s $SESSION -n 'Node1'


# Criando janela :1
tmux new-window -t $SESSION:2 -n 'Node2'

# Criando Janela :2 
tmux new-window -t $SESSION:3 -n 'Node3'

# Criando janela :3 
tmux new-window -t $SESSION:4 -n 'Node4'

# Criando janela :4 
tmux new-window -t $SESSION:5 -n 'Node5'



# Set conections
##0
tmux select-window -t $SESSION:1
tmux send-keys "cd $KEYFOLDER && ssh -i "$KEYFILE1" $SERVER1" C-m

##1
tmux select-window -t $SESSION:2
tmux send-keys "cd $KEYFOLDER && ssh -i "$KEYFILE1" $SERVER2" C-m
##2
tmux select-window -t $SESSION:3
tmux send-keys "cd $KEYFOLDER && ssh -i "$KEYFILE1" $SERVER3" C-m
##3
tmux select-window -t $SESSION:4
tmux send-keys "cd $KEYFOLDER && ssh -i "$KEYFILE1" $SERVER4" C-m
##4
tmux select-window -t $SESSION:5
tmux send-keys "cd $KEYFOLDER && ssh -i "$KEYFILE1" $SERVER5" C-m


# Set main window
tmux select-window -t $SESSION:1

# Attach to session
tmux -2 attach-session -t $SESSION
#RTM
