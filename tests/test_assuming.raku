use v6;

sub f(\x,\y,\z) { x+y+z};

my \vx=1;
my \vy=2;
my \g = &f.assuming(vx,vy);

say g.(3);
