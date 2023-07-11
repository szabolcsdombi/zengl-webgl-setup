FROM python:3.11.2 AS base
ENV EMSDK=/opt/emsdk EMSDK_NODE=/opt/emsdk/node/14.18.2_64bit/bin/node \
    PATH=/opt/emsdk:/opt/emsdk/upstream/emscripten:/opt/emsdk/node/14.18.2_64bit/bin:$PATH
RUN git clone https://github.com/emscripten-core/emsdk.git $EMSDK &&\
    emsdk install 3.1.32 && emsdk activate 3.1.32 && pip install pyodide-build==0.23.4

RUN git clone https://github.com/szabolcsdombi/zengl -b 1.13.0 /zengl
RUN pyodide build /zengl -o /web/

COPY webgl /webgl
RUN pyodide build /webgl -o /web/

WORKDIR /web/
COPY index.html webgl.js main.py /web/
CMD python -m http.server --bind 0.0.0.0 8000
