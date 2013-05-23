%Instructions%
%place in the same folder as time lapse%
%type q2%

I= im2double(imread('image001.png'));
[U S V]=svd(I);

plot(diag(S),'b.')
saveas(gcf,'plot','bmp');

K=20;
Sk=S(1:K,1:K);
Uk=U(:,1:K);
Vk=V(:,1:K);

Imk=Uk*Sk*Vk';
imshow(Imk);
saveas(gcf,'k20','bmp');

K=40;
Sk1=S(1:K,1:K);
Uk1=U(:,1:K);
Vk1=V(:,1:K);

Imk1=Uk1*Sk1*Vk1';
imshow(Imk1);
saveas(gcf,'k40','bmp');

K=60;
Sk2=S(1:K,1:K);
Uk2=U(:,1:K);
Vk2=V(:,1:K);

Imk2=Uk2*Sk2*Vk2';
imshow(Imk2);
saveas(gcf,'k60','bmp');

K=80;
Sk3=S(1:K,1:K);
Uk3=U(:,1:K);
Vk3=V(:,1:K);

Imk3=Uk3*Sk3*Vk3';
imshow(Imk3);
saveas(gcf,'k80','bmp');