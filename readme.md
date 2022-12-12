
# m11 iot trigger hub

This repo contains all the project code:  

[https://github.com/mnhuoi/m11_iot_trigger_hub](https://github.com/mnhuoi/m11_iot_trigger_hub)

```bash
Note only ubuntu 22.04.1 LTS (Jammy Jellyfish) was tested

Before you can launch you need to install dependencies
```

# what it does

- The m11_iot_trigger_hub wraps the flic2 linux sdk allowing flic2 bluetooth buttons to trigger linux commands that are configurable from the m11.json

- Allows flic2 iot buttons to trigger anything on the local host linux device or anything reachable via an http post method

- Uses a single configuration file for all configurations

# why the flic2 button?

- The flic linux sdk offers both basic html/js skeleton and a basic cpp example to interact with the flic 2 buttons
without relying on the system bluetooth stack. While this requires its own dedicated bluetooth adapter if used in 
conjunction with other bluetooth devices, it is much more straightforward and portable. 
- The buttons themselves are also smaller and simpler than other iot buttons I tested.

# intended functionality / features I didn't have time to implement

- fully generic local_commands without heavy coupling of local_commands inside local_cmd_listener

- allow webpage gui to modify and update m11.json

- support more protocols and devices

- website with tie in for multiple m11 connections / aggregator for all devices

- in general I intended for this tool to be more generic and automatic, support more devices, and have a better looking webpage. Never the less, I made signficant progress for 31 hours

# install dependencies

1. clone the repo 
    ```bash
     git clone https://github.com/mnhuoi/m11_iot_trigger_hub.git
    ```
2. install screen
    ```bash
    sudo apt install -y screen
    ```
3. install xterm
    ```bash
    sudo apt install -y xterm
    ```
3. modify /etc/sudoers with pkexec visudo
    ```bash
    pkexec visudo

    then add the following lines replacing `whoami` 
    with your user and ${START} with your cloned repo
    fullpath

    `whoami` ALL=(ALL) NOPASSWD: ${START}/launch_m11 
    `whoami` ALL=(ALL) NOPASSWD: /usr/bin/screen
    ```

5. (Optional) install chrome
    ```bash
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

    sudo dpkg -i google-chrome-stable_current_amd64.deb
    ```

6. (Optional) edit m11.json
    ```bash
    Add additional known_commands or buttons, modify trigger_actions / trigger_values. 
    Note use the frontend to register new devices with flicd. 
    known_commands, trigger_actions and trigger_values can be changed 
    at any time for a registered button.
    ```

# launch_m11

1. open m11 with bash
    ```bash
    cd <to cloned repo directory>

    bash launch_m11
    ```

# Code overview

1. Main processes
- `bash launch_m11` 
Primary launcher that invokes flic2_server, flic2_websocket, local_frontend_watcher, btmon, local_cmd_listener, and kills / manages any already running processes. 
`This is the only process you need to launch.`

- `front_end` will open in firefox or chrome depending on which is set in the m11.json 

2. Configuration Files
- `m11.json` All configuration is done with m11.json, additions to this file will be added to the frontend each time it is launched.

    ```json
    {
    "START":"/home/test/m11_iot_trigger_hub",
    "USE_FIREFOX_OR_CHROME":"google-chrome",
    "LOCAL_COMMAND_LISTENER_PORT":"7993",
    "flic_server_ws_port":"5551",
    "flic_client_ws_port":"5553",
    "button0": {
    "bd_addr":"80:e4:da:79:f5:24",
    "trigger_action":"open_tab",
    "trigger_value":"https://www.google.com/search?q=cat+biscuits"
    },                                              
    "button1": {                                               
    "bd_addr":"80:e4:da:79:b7:89",                              
    "trigger_action":"open_tab",                                 
    "trigger_value":"https://www.google.com/search?q=bitcoin+news" 
    },                                               
    "button2": {                                                
    "bd_addr":"80:e4:da:79:f5:4f",                                 
    "trigger_action":"local_command",                              
    "trigger_value":"reinit" 
    },
    "button3": {                                                
    "bd_addr":"80:e4:da:79:f5:4w",                                 
    "trigger_action":"open_tab",                                   
    "trigger_value":"https://www.google.com/search?q=how+to+cook+steak"
    },
    "comment leave known_commands as last item for launch_m11 parsing":"",
    "comment local commands possible are in known_commands below":"",
    "known_commands":[
    "reinit",
    "shutdown"
    ]
    }
    ```

2. managed components

- `flic2_server` launches flicd backend

- `flic2_delete_devices` deletes flicd db for devices

- `flic2_websocket` launches flic2 websocketproxy

- `local_frontend_watcher` watches chrome or firefox ps and restarts local_frontend_launcher if it stops while m11 is running

- `local_frontend_launcher` launches chrome or firefox with frontend

- `local_cmd_listener` an open socket that executes commands triggered by flic2 buttons on the host machine

- `get_json_key_value` returns the value of a json key

```bash
#  when you are done

cd <to cloned repo directory>

bash launch_m11 clean

# will close all m11 processes
```
