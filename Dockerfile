FROM python:3.11.3
ENV EMSDK=/opt/emsdk EMSDK_NODE=/opt/emsdk/node/16.20.0_64bit/bin/node \
    PATH=/opt/emsdk:/opt/emsdk/upstream/emscripten:/opt/emsdk/node/16.20.0_64bit/bin:$PATH
RUN git clone https://github.com/emscripten-core/emsdk.git $EMSDK &&\
    emsdk install 3.1.45 && emsdk activate 3.1.45 && pip install pyodide-build==0.24.1

RUN git clone https://github.com/szabolcsdombi/zengl -b 1.14.0 /zengl
RUN pyodide build /zengl -o /web/

COPY webgl /webgl
RUN pyodide build /webgl -o /web/

WORKDIR /web/
COPY index.html webgl.js main.py /web/
CMD python -m http.server --bind 0.0.0.0 8000
