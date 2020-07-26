#FROM continuumio/miniconda3
FROM tensorflow/tensorflow:1.13.1-gpu-py3

# Conda prerequisites
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini


COPY . /home/soft/fetch
WORKDIR /home/soft/fetch
RUN conda install -c anaconda \
                              #cudatoolkit==10.0.130 \
                              #tensorflow-gpu==1.13.1 \
                              keras \
                              scikit-learn \
                              pandas \
                              scipy \
                              numpy \
                              matplotlib \
                              scikit-image \
                              tqdm \
                              numba \
                              pyyaml=3.13 && \
    python setup.py install

WORKDIR /home/soft
RUN git clone https://github.com/devanshkv/pysigproc.git && \
    cd pysigproc && \
    python setup.py install
