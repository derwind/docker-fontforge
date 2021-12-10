FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
    apt install -y libjpeg-dev libtiff5-dev libpng-dev libfreetype6-dev libgif-dev libgtk-3-dev libxml2-dev libpango1.0-dev libcairo2-dev libspiro-dev python3-dev ninja-build cmake build-essential gettext && \
    apt install -y git

# from setup_linux_deps.sh
#ENV GITHUB_WORKSPACE /workdir/fontforge
#ENV PREFIX $GITHUB_WORKSPACE/target
#ENV DEPSPREFIX $GITHUB_WORKSPACE/deps/install
#ENV PATH $PATH:$DEPSPREFIX/bin:$PREFIX/bin:~/.local/bin
#ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$DEPSPREFIX/lib:$PREFIX/lib
#ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:$DEPSPREFIX/lib/pkgconfig
#ENV PYTHONPATH $PYTHONPATH:$PREFIX/$($PYTHON -c "import distutils.sysconfig as sc; print(sc.get_python_lib(prefix='', plat_specific=True,standard_lib=False))")

RUN mkdir /workdir && \
    cd /workdir && \
    git clone https://github.com/fontforge/fontforge.git && \
    cd fontforge && \
    mkdir build && \
    cd build && \
    cmake -GNinja .. && \
    ninja && \
    ninja install && \
    cp lib/fontforge.so lib/psMat.so /usr/lib/python3/dist-packages/ && \
    cp lib/libfontforge.so.4 /usr/lib/ && \
    cd /usr/bin && ln -s libfontforge.so.4 libfontforge.so && \
    cd /usr/bin && ln -s python3 python && \
    cd /workdir && \
    rm -rf fontforge

WORKDIR /workdir

CMD ["python3"]
