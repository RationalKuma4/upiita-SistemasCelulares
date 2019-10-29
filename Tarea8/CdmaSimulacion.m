clear all;
close all;
clc;

%% 2 Codificacion de proveedor
% Proveedor telcel 334020
% -Reglas
% 3(incial) y 0(final), mismo para todos los proveedores, asi que se omiten
% 1 pos: 1->0, 3->1
% 2 pos: 0->00, 1->01, 4->10
% 3 pos: 0->00, 1->01, 2->10, 3->11
% 4 pos: 1->00, 2->01, 3->10, 5->11
tramaPorveedor=[1 1 0 0 0 0 1];
tramaPorveedorNrz=tramaPorveedor*2-1;

figure(1);
subplot(6,1,1);
stairs(0:length(tramaPorveedorNrz), [tramaPorveedorNrz 1],'LineWidth',1.5);
% Matlab empieza en 1 	¯\_(?)_/¯
% stairs([tramaPorveedorNrz 1]);
ylim([-1.4 1.4]);
xlim([0 7]);
title('Proveedor')
grid on;

%% 3 Matriz de Hadamard 16*16
H=hadamard(16);
t = 0:0.02:16;
f=.5;
x=sin(2*pi*f*t);
x(x<0) = x(x<0)*-1; % Rectificar señal

signals=zeros(16,801);
signalOne=zeros(1,801);
for j=1:length(H)
    factor=H(j,:);
    
    for i=1:length(x)
        if(1<=i && i<51)
            signalOne(i)=x(i)*factor(1);
        end
        
        if(52<=i && i<101)
            signalOne(i)=x(i)*factor(2);
        end
        
        if(102<=i && i<151)
            signalOne(i)=x(i)*factor(3);
        end
        
        if(152<=i && i<201)
            signalOne(i)=x(i)*factor(4);
        end
        
        if(202<i && i<251)
            signalOne(i)=x(i)*factor(5);
        end
        
        if(252<i && i<301)
            signalOne(i)=x(i)*factor(6);
        end
        
        if(302<i && i<351)
            signalOne(i)=x(i)*factor(7);
        end
        
        if(352<i && i<401)
            signalOne(i)=x(i)*factor(8);
        end
        
        if(402<i && i<451)
            signalOne(i)=x(i)*factor(9);
        end
        
        if(452<i && i<501)
            signalOne(i)=x(i)*factor(10);
        end
        
        if(502<i && i<551)
            signalOne(i)=x(i)*factor(11);
        end
        
        if(552<i && i<601)
            signalOne(i)=x(i)*factor(12);
        end
        
        if(602<i && i<651)
            signalOne(i)=x(i)*factor(13);
        end
        
        if(652<i && i<701)
            signalOne(i)=x(i)*factor(14);
        end
        
        if(702<i && i<751)
            signalOne(i)=x(i)*factor(15);
        end
        
        if(752<i && i<801)
            signalOne(i)=x(i)*factor(16);
        end
    end
    
    signals(j,:)=signalOne;
end

for i=2:4
    subplot(6,1,i)
    plot(t,signals(i,:),'LineWidth',1.5);
    title(mat2str(H(i,:)));
    grid on;
end

%% 4 Simulacion QPSK
% Sevicio: W->-1, F->1
% Usuario a 8 posiciones 1-16
servicio=-1;
usuario=de2bi(5,8,'left-msb')*2-1;
trama=[servicio tramaPorveedorNrz usuario];

s_p_data=reshape(trama,2,length(trama)/2); 
br=10.^6; 
f=br; 
T=1/br;
t=T/99:T/99:T; 
y=[];
y_in=[];
y_qd=[];

for(i=1:length(trama)/2)
    y1=s_p_data(1,i)*cos(2*pi*f*t); % inphase component
    y2=s_p_data(2,i)*sin(2*pi*f*t) ;% Quadrature component
    y_in=[y_in y1]; % inphase signal vector
    y_qd=[y_qd y2]; %quadrature signal vector
    y=[y y1+y2]; % modulated signal vector
end
Tx_sig=y; 
tt=T/99:T/99:(T*length(trama))/2;
subplot(6,1,6);
plot(tt,Tx_sig,'linewidth',1.5), 
grid on;
title('Codigo modulado QPSK');

subplot(6,1,5);
stairs(0:length(trama), [trama 1],'linewidth',1.5), 
grid on;
title('Trama codififcada');

%% 4 Prueba de ortoganilidad
% Lineas de prueba tomadas del punto anterior
testLines=[H(2,:); H(3,:); H(4,:)];
esOrtogonal=1;
for i=1:size(testLines,1)
    testLine=testLines(i,:);
    
    for j=6:16
        if(dot(testLine,H(j,:))~=0)
            esOrtogonal=0;
            break;
        end
    end
end

if(esOrtogonal==1)
    disp('Es ortogonal');
else
    disp('No es ortogonal');
end
