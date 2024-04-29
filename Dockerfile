# ### BUILD MAIN IMAGE START ###
FROM alpine

RUN apk add --no-cache --update bash git python3 sed util-linux-misc

SHELL ["/bin/bash", "-c"]

# ## HamsterKombatBot setup ##
RUN git clone https://github.com/shamhi/HamsterKombatBot.git
RUN cd HamsterKombatBot && python3 -m venv venv && source venv/bin/activate && pip3 install -r requirements.txt

# ## MemeFiBot setup ##
RUN git clone https://github.com/shamhi/MemeFiBot.git
RUN cd MemeFiBot && python3 -m venv venv && source venv/bin/activate && pip3 install -r requirements.txt

# ## PocketFiBot setup ##
RUN git clone https://github.com/shamhi/PocketFiBot.git
RUN cd PocketFiBot && python3 -m venv venv && source venv/bin/activate && pip3 install -r requirements.txt

# ## TapSwapBot setup ##
RUN git clone https://github.com/shamhi/TapSwapBot.git
RUN cd TapSwapBot && python3 -m venv venv && source venv/bin/activate && pip3 install -r requirements.txt

# ## WormSlapBot setup ##
RUN git clone https://github.com/shamhi/WormSlapBot.git
RUN cd WormSlapBot && python3 -m venv venv && source venv/bin/activate && pip3 install -r requirements.txt

COPY start.sh .

VOLUME ["/config"]
VOLUME ["/HamsterKombatBot/sessions"]
VOLUME ["/MemeFiBot/sessions"]
VOLUME ["/PocketFiBot/sessions"]
VOLUME ["/TapSwapBot/sessions"]
VOLUME ["/WormSlapBot/sessions"]
ENTRYPOINT ["./start.sh"]
### BUILD MAIN IMAGE end ###
