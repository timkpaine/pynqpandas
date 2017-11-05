from setuptools import setup, find_packages
from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))

with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='pynqpandas',
    version='0.0.1',
    description='Hardware-accelerated Pandas',
    long_description=long_description,
    url='https://github.com/timkpaine/pynqpandas',
    download_url='https://github.com/timkpaine/pynqpandas/archive/v0.0.4.tar.gz',
    author='Tim Paine',
    author_email='timothy.k.paine@gmail.com',
    license='GPL',

    classifiers=[
        'Development Status :: 3 - Alpha',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
    ],

    keywords='pandas fpga',

    # You can just specify the packages manually here if your project is
    # simple. Or you can use find_packages().
    packages=find_packages(exclude=[]),
)
