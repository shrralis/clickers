### BUILD CLICKERS MULTIARCH START ###
FROM --platform=$BUILDPLATFORM alpine AS builder
#FROM --platform=linux/arm64 alpine AS builder

WORKDIR /clickers

RUN apk add --no-cache --update bash git python3

ARG TARGETARCH
ARG TARGETVARIANT
RUN if [ "$TARGETARCH" == 'arm64' ] && [ -z "$TARGETVARIANT" ]; then apk add build-base python3-dev; fi

SHELL ["/bin/bash", "-c"]

# ## HamsterKombatBot setup ##
RUN git clone https://github.com/shamhi/HamsterKombatBot.git
RUN cd HamsterKombatBot && python3 -m venv venv && . venv/bin/activate && pip3 install -r requirements.txt

# ## MemeFiBot setup ##
RUN git clone https://github.com/shamhi/MemeFiBot.git
RUN cd MemeFiBot && python3 -m venv venv && . venv/bin/activate && pip3 install -r requirements.txt

# ## PocketFiBot setup ##
RUN git clone https://github.com/shamhi/PocketFiBot.git
RUN cd PocketFiBot && python3 -m venv venv && . venv/bin/activate && pip3 install -r requirements.txt

# ## TapSwapBot setup ##
RUN git clone https://github.com/shamhi/TapSwapBot.git
RUN cd TapSwapBot && python3 -m venv venv && . venv/bin/activate && pip3 install -r requirements.txt

# ## WormSlapBot setup ##
RUN git clone https://github.com/shamhi/WormSlapBot.git
RUN cd WormSlapBot && python3 -m venv venv && . venv/bin/activate && pip3 install -r requirements.txt
### BUILD CLICKERS MULTIARCH END ###


# ### BUILD MAIN IMAGE START ###
FROM --platform=linux/arm64 alpine

WORKDIR /clickers

RUN apk add --no-cache --update bash git python3 sed util-linux-misc

COPY --from=builder ./clickers .
COPY start.sh .

VOLUME ["/clickers/config"]
VOLUME ["/clickers/HamsterKombatBot/sessions"]
VOLUME ["/clickers/MemeFiBot/sessions"]
VOLUME ["/clickers/PocketFiBot/sessions"]
VOLUME ["/clickers/TapSwapBot/sessions"]
VOLUME ["/clickers/WormSlapBot/sessions"]

CMD ["./start.sh"]
### BUILD MAIN IMAGE end ###
