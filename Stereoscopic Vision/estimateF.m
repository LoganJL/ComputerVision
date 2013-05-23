function F = estimateF(x1, x2)
   
base_points = x1.';
input_points = x2.';
[m n]=size(input_points);
%Normalize matrix%

%norm of input and base%
nmag_input=norm(input_points);
nmag_base=norm(base_points);
r2=sqrt(2);

%scaling factor%
sl_input=r2/nmag_input;
sl_base=r2/nmag_base;

%create transition matrices%
Tinput = zeros(3,3);
Tbase = zeros(3,3);

%scale the points and then determine centroid to shift by%
temp_input = sl_input*input_points;
temp_base = sl_base*base_points;

centerx_input = mean(temp_input(:,1));
centery_input = mean(temp_input(:,2));

centerx_base = mean(temp_base(:,1));
centery_base = mean(temp_base(:,2));

%create transition matrices%
Tinput(1,1) = sl_input;
Tinput(1,3) = -centerx_input;
Tinput(2,2) = sl_input;
Tinput(2,3) = -centery_input;
Tinput(3,3) = 1;

Tbase(1,1) = sl_base;
Tbase(1,3) = -centerx_base;
Tbase(2,2) = sl_base;
Tbase(2,3) = -centery_base;
Tbase(3,3) = 1;

%create normalized matrices%
norm_input=zeros([m 3]);
norm_base=zeros([m 3]);

Ones = ones([m 1]);

%pad the input points by one%
input_points = cat(2,input_points,Ones);
base_points = cat(2,base_points,Ones);

%apply transition matrices%
for i=1:size(input_points,1)
    norm_input(i,:)=Tinput*input_points(i,:)';
    norm_base(i,:)=Tbase*base_points(i,:)';
end

A = zeros([m 9]);

%populate A%
for i=1:m
        A(i,1)=norm_base(i,1)*norm_input(i,1);
        A(i,2)=norm_base(i,1)*norm_input(i,2);
        A(i,3)=norm_base(i,1);
        A(i,4)=norm_base(i,2)*norm_input(i,1);
        A(i,5)=norm_base(i,2)*norm_input(i,2);
        A(i,6)=norm_base(i,2);
        A(i,7)=norm_input(i,1);
        A(i,8)=norm_input(i,2);
        A(i,9)=1;
end

%SVD of A%
[U S V] = svd(A);

%Take Fundamental Matrices%
F=V(:,end);

%reshape it and denoise it%
F = reshape(F,3,3);
[Uf Sf Vf] = svd(F);
Sf(3,3) = 0;

F_denoise = Uf*Sf*Vf';

F_final = Tbase'*F_denoise*Tinput;

F=F_final;





       
    
    









    
    