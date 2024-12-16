
FROM curobo_docker:x86

ARG GIT_USERNAME
ARG GIT_EMAIL

WORKDIR /home/ros2_ws/src
RUN git clone https://github.com/Lab-CORO/CapaciNet.git  -b main

WORKDIR /home
RUN git clone https://github.com/rogersce/cnpy.git
RUN cd cnpy && mkdir build && cd build && cmake .. && make && make install

RUN git config --global user.name "$GIT_USERNAME" && \
    git config --global user.email "$GIT_EMAIL"

RUN sudo apt-get install libhdf5-dev
RUN git clone --recursive https://github.com/BlueBrain/HighFive.git

WORKDIR /home/HighFive
RUN git checkout v2.8.0
RUN git submodule update --init --recursive

RUN cmake -DCMAKE_INSTALL_PREFIX=build/install -DHIGHFIVE_USE_BOOST=Off -B build .
RUN cmake --build build --parallel
RUN cmake --install build
RUN export CMAKE_PREFIX_PATH="/home/HighFive/build/install:${CMAKE_PREFIX_PATH}"

RUN apt update && apt install ccache -y
WORKDIR /home
RUN git clone https://github.com/isl-org/Open3D
RUN cd Open3D && util/install_deps_ubuntu.sh assume-yes

WORKDIR /home/Open3D
RUN mkdir build 
WORKDIR /home/Open3D/build 
RUN cmake .. -DBUILD_PYTHON_MODULE=OFF 
RUN make -j$(nproc) && make install


WORKDIR /home/ros2_ws
RUN apt remove python3-blinker -y
RUN pip install open3d
ENV CMAKE_PREFIX_PATH='/home/HighFive/build/install:${CMAKE_PREFIX_PATH}'
