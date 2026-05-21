# Reproducible TeX Live build environment (2026 template)
FROM texlive/texlive:latest-full

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    PATH="/root/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    git \
    curl \
    ca-certificates \
    pandoc \
    imagemagick \
    python3 \
    python3-pip \
    nodejs \
    npm \
    default-jre \
    librsvg2-bin \
    xindy \
    && rm -rf /var/lib/apt/lists/*

# just command runner
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

# EPUBCheck 5
RUN mkdir -p /opt/epubcheck && \
    curl -fsSL -o /tmp/epubcheck.zip \
      "https://github.com/w3c/epubcheck/releases/download/v5.1.0/epubcheck-5.1.0.zip" && \
    unzip -q /tmp/epubcheck.zip -d /opt/epubcheck && \
    ln -sf /opt/epubcheck/epubcheck-5.1.0/epubcheck.jar /opt/epubcheck/epubcheck.jar && \
    printf '#!/bin/sh\nexec java -jar /opt/epubcheck/epubcheck.jar "$@"\n' > /usr/local/bin/epubcheck && \
    chmod +x /usr/local/bin/epubcheck && \
    rm /tmp/epubcheck.zip

WORKDIR /book
COPY . /book

RUN just doctor || true

CMD ["just", "all"]
