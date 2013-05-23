%Before running, run example1.c in KL tracker after changing the parameters
%to frc1.pgm and frc2.pgm respectively.  Note that you will need to convert
%the frc files from .tif to .pgm
%Then run the modified ktl_read_featuretable(filename) for feat1.txt and
%feat2.txt respectively and pass the parameters to [x y val] and 
%[xprime yprime val prime] respectively.

%condition the points to pass into estimateF%
frc1 = im2double(imread('frc1.tif'));
frc2 = im2double(imread('frc2.tif'));

x = x.';
y = y.';

xprime = xprime.';
yprime = yprime.';

%concatenate the input and base points to obtain 2 2xn matrices%
input_points = cat(1,x,y);
base_points = cat(1,xprime,yprime)

imshow(frc1);
hold on;

for i=1:size(input_points,2)
    plot(input_points(1,i),input_points(2,i),'b.');
end

%save the plot%

imshow(frc2);
hold on;

for i=1:size(base_points,2)
    plot(base_points(1,i),input_points(2,i),'b.');
end

%save the plot%

F = estimateF(input_points,base_points);

displayEpipolarF(frc1,frc2,F);


