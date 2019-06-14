from setuptools import setup

setup(
   name='endomorphisms',
   version='0.4',
   description='Computing endomorphism rings of Jacobians',
   author='Edgar Costa, Jeroen Hanselman, Davide Lombardo, Nicolas Mascot, Jeroen Sijsling, and John Voight',
   author_email='edgarcosta@math.dartmouth.edu, jeroen.sijsling@uni-ulm.de',
   packages=['endomorphisms'],
   package_data={'endomorphisms': ['magma/*', 'magma/bounds/*', 'magma/heuristic/*', 'magma/polarization/*', 'magma/puiseux/*', 'bounds/*', 'OverFiniteField/*', 'UpperBounds/*', 'newton/*']},
   install_requires=[ ],
)
