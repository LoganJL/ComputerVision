function [newObject] = drawPhotometricStereo(normals, albedo, object,name)

    [I J] = find(albedo);
    nPixels = size(I,1);
    nrows = size(object,1);
    ncols = size(object,2);

    maxalbedo = max(max(albedo));
    albedo = albedo/maxalbedo;

    original = imshow(object,[0,0.05]);
    saveas(original,strcat(name,'_original.png'));
    hold on;
    
    for i=1:20:nrows
        for j=1:20:ncols

            if (object(i,j)~=0)

                u = normals(i,j,1);
                v = normals(i,j,2);
                w = normals(i,j,3);
                %u = u/w;
                %v = v/w;

                %arrowline([j,j+u*5],[i,i+v*5]);
                %quiver(j,i,u*10,v*10,0.5,'-b');
                quiver3(j,i,1,u*15,v*15,w*15,0.5,'b');
            end
        end
    end
    
    saveas(original,strcat(name,'_originalvectors.png'));
    
    rgb = zeros(600,800,3);
    for i=1:nrows
        for j=1:ncols
            if (object(i,j)~=0)
                rgb(i,j,1)=0.5*(1.0+normals(i,j,1));
                rgb(i,j,2)=0.5*(1.0+normals(i,j,2));
                rgb(i,j,3)=0.5*(1.0+normals(i,j,3));
            end
        end
    end
    
    
    
    
    
    
    rgbDrawing = imshow(rgb,[0 0.05]);
    for i=1:20:nrows
        for j=1:20:ncols

            if (object(i,j)~=0)

                u = normals(i,j,1);
                v = normals(i,j,2);
                w = normals(i,j,3);
                %u = u/w;
                %v = v/w;

                %arrowline([j,j+u*5],[i,i+v*5]);
                %quiver(j,i,u*10,v*10,0.5,'-b');
                quiver3(j,i,1,u*15,v*15,w*15,0.5,'b');
            end
        end
    end
    saveas(rgbDrawing,strcat(name,'_normalvectors.png'));
    clf;
    rgbDrawing1 = imshow(rgb,[0 0.05]);
    saveas(rgbDrawing1,strcat(name,'_normalfield.png'));
    
    
    
    clf;
    
    albedoDrawing=zeros(600,800,3);
    for i=1:nrows
        for j=1:ncols
            if (object(i,j)~=0)
                albedoDrawing(i,j,1)=0.1^albedo(i,j);
                albedoDrawing(i,j,2)=0.1^albedo(i,j);
                albedoDrawing(i,j,3)=0.1^albedo(i,j);
            end
        end
    end
    
    albedoImage=imshow(albedoDrawing);
    saveas(albedoImage,strcat(name,'_albedo.png'));
    
    clf;
    
    %set lightIntensity to 0.5;
    lightIntensity = 0.5;
    rerenderedObject=zeros(600,800);
    
    for i=1:nrows
        for j=1:ncols
            if (object(i,j)~=0)
                %assuming direction vector of lighting is [0,0,1]
                rerenderedObject(i,j) = lightIntensity*albedo(i,j)*(normals(i,j,3)*1);
            end
        end
    end
    
    rerendered=imshow(rerenderedObject);
    saveas(rerendered,strcat(name,'_rerendered_05.png'));
    
    
    
    
end
    
