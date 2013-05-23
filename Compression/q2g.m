%Instructions%
%Place file in time-lapse folder%
%Type q2g, and use ffmpeg to compile the frames to a video%


%take the file names%

files = dir('*.png');

%read the first file, reshape it and create an empty mean centered matrix%
input = im2double(imread(files(1).name));
input = reshape(input,42021,1);
data = input;
meancentered = zeros(42021,150);

%read all the files in and vectorize them into one matrix data%
for i=2:size(files)
        input = im2double(imread(files(i).name));
        input = reshape(input,42021,1);
        data = cat(2,data,input);
        
end

%mean center the matrix data in another matrix called meancentered%
for j=1:150
    meanc = mean(data(1:end,j));
    for k =1:size(data,1)
        meancentered(k,j)=data(k,j)-meanc;
    end
end

%svd of the matrix%
[U, S, V] = svd(meancentered,'econ');

%extract the first 10 principal components%
k = 10;

Sk = S(1:k,1:k);
Uk = U(:,1:k);
Vk = V(:,1:k);

%reconstruct the matrix%
Output = Uk*Sk*V';

%write the images to a file after reshaping them%
for i=1:150
        o=output(1:end,i);
        im_output=reshape(o,161,261);
        imwrite(im_output,['output',num2str(i),'.jpg'],'jpg');
        
end


        
       