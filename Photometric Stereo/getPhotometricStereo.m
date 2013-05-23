function [surfNormals, albedo, object] = getPhotometricStereo(imageDir)

    myFiles = dir(fullfile(imageDir,'*.pbm'));
    totalFileNum = size(myFiles,1);
    imcell = cell(totalFileNum,1);

    %Load pbm Images
    for i=1:totalFileNum
        filename = [imageDir,'\',myFiles(i).name];
        imcell{i}=rgb2gray(im2double(imread_pfm(filename)));
    end;

    %Load Metallic Sphere Masks
    
    MSphere1_filename = [imageDir,'\','mask_dir_1.png'];
    MSphere2_filename = [imageDir,'\','mask_dir_2.png'];
    MSphere1 = rgb2gray(im2double(imread(MSphere1_filename)));
    MSphere2 = rgb2gray(im2double(imread(MSphere2_filename)));

    %Find co-ordinates of nonzero elements
    [MSphere1_I,MSphere1_J] = find(MSphere1);
    [MSphere2_I,MSphere2_J] = find(MSphere2);

    %Find center of metallic spheres

    MSphere1_rad = (max(MSphere1_I) - min(MSphere1_I))/2;
    MSphere1_cx = min(MSphere1_I) + MSphere1_rad;
    MSphere1_cy = min(MSphere1_J) + MSphere1_rad;

    MSphere2_rad = (max(MSphere2_I) - min(MSphere2_I))/2;
    MSphere2_cx = min(MSphere2_I) + MSphere2_rad;
    MSphere2_cy = min(MSphere2_J) + MSphere2_rad;

    LSphere_filename = [imageDir,'\','mask_I.png'];
    LSphere = rgb2gray(im2double(imread(LSphere_filename)));

    % R is the the reflection direction
    R = [0 0 1.0];

    % This is the 2 light directions determined from both spheres
    LdValues = zeros(totalFileNum,3,2);
    % This represents the average light direction from both spheres
    AverageLdValue = zeros(totalFileNum,3);

    for i=1:totalFileNum

        Mask1 = MSphere1.*imcell{i};
        Mask2 = MSphere2.*imcell{i};

        maxval1 = max(max(Mask1));
        maxval2 = max(max(Mask2));

        [max1_I,max1_J]=find(Mask1 == maxval1);
        [max2_I,max2_J]=find(Mask2 == maxval2);

        nSize1 = size(max1_I,1);
        nSize2 = size(max2_I,1);

        max1_I = sum(max1_I)/double(nSize1);
        max1_J = sum(max1_J)/double(nSize1);

        max2_I = sum(max2_I)/double(nSize2);
        max2_J = sum(max2_J)/double(nSize2);

        N1_x = max1_I - MSphere1_cx;
        N1_y = max1_J - MSphere1_cy;
        N1_z = sqrt(MSphere1_rad^2-N1_x^2-N1_y^2);

        N2_x = max2_I - MSphere2_cx;
        N2_y = max2_J - MSphere2_cy;
        N2_z = sqrt(MSphere2_rad^2-N2_x^2-N2_y^2);

        normal1 = [N1_x,N1_y,N1_z];
        normal2 = [N2_x,N2_y,N2_z];

        normal1 = normal1/MSphere1_rad;
        normal2 = normal2/MSphere2_rad;

        normalR1 = normal1*R';
        normalR2 = normal2*R';
        LdValues(i,:,1) = 2*normalR1*normal1-R;
        LdValues(i,:,2) = 2*normalR2*normal2-R;

        AverageLdValue(i,:)=(LdValues(i,:,1) + LdValues(i,:,2))/2;

    end;
    
    %hardcoding mask names;
    if (strcmp(imageDir,'Apple'))
        Mask_filename = [imageDir,'\','applemask.png'];
    else
        Mask_filename = [imageDir,'\','mask.png'];
    end
    
    objectMask = rgb2gray(im2double(imread(Mask_filename)));
    object=imcell{1}.*objectMask;
    [Obj_I,Obj_J]=find(object);
    nPixels = size(Obj_I,1);
    I = zeros(totalFileNum,1);
    surfNormals = zeros(600,800,3);
    albedo = zeros(600,800);

    for i=1:nPixels
        for n=1:totalFileNum
            pixel_i = Obj_I(i);
            pixel_j = Obj_J(i);
            object=imcell{n}.*objectMask;
            I(n)=object(pixel_i,pixel_j);
        end
        
     
        L = AverageLdValue;
        A = L;
        b = I;
        G = A\b;
        albedoValue = norm(G);
        N = G/albedoValue;

        surfNormals(pixel_i,pixel_j,1) = N(1);
        surfNormals(pixel_i,pixel_j,2) = N(2);
        surfNormals(pixel_i,pixel_j,3) = N(3);
        albedo(pixel_i,pixel_j) = albedoValue;

    end;
end




    
    
    

    







        
       
            



    
    
    
    
    
    
    
    


    


