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
% Objetos para proveedores de servicio
telcel=Proveedor();
telcel.Nombre='Telcel';
telcel.Codigo=[1 1 0 0 0 0 1];

movistar=Proveedor();
movistar.Nombre='Movistar';
movistar.Codigo=[1 1 0 0 0 1 0];

iu=Proveedor();
iu.Nombre='Iusacel-Unefon';
iu.Codigo=[1 0 1 0 0 1 1];

at=Proveedor();
at.Nombre='AT&T';
at.Codigo=[0 0 0 1 1 0 0];
proveedores = {telcel, movistar, iu, at};

% Seleccion aleatoria de proveedor
p = randi([1 4],1,1);
p=1;
prov=Proveedor();
switch p
    case 1
        prov = proveedores{1};
    case 2
        prov = proveedores{2};
    case 3
        prov = proveedores{3};
    case 4
        prov = proveedores{4};
end
disp(strcat('Proveedor: ', prov.Nombre))

% Sevicio: W->-1, F->1
servicio=randi([0 1],1,1)*2-1;
servicio=1;
if(servicio==1)
    disp('Servicio:Face');
else
    disp('Servicio:Whats');
end

% Convertir a NRZ
%tramaPorveedor=[1 1 0 0 0 0 1];
prov.CodigoNZR=prov.Codigo*2-1;

figure(1);
subplot(6,1,1);
stairs(0:length(prov.CodigoNZR), [prov.CodigoNZR prov.CodigoNZR(7)],'LineWidth',1.5);
% Matlab empieza en 1 	¯\_(?)_/¯
% stairs([tramaPorveedorNrz 1]);
ylim([-1.4 1.4]);
xlim([0 7]);
title(strcat('Proveedor: ',prov.Nombre));
grid on;

%% 3 Matriz de Hadamard 16*16 (usuarios)
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

% Elegir y graficar señales aleatorias
signalOne=randi([1 16],1,1);
signalTwo=randi([1 16],1,1);
signalThree=randi([1 16],1,1);
signalThree=5;

subplot(6,1,2)
plot(t,signals(signalOne,:),'LineWidth',1.5);
title(mat2str(H(signalOne,:)));
grid on;

subplot(6,1,3)
plot(t,signals(signalTwo,:),'LineWidth',1.5);
title(mat2str(H(signalTwo,:)));
grid on;

subplot(6,1,4)
plot(t,signals(signalThree,:),'LineWidth',1.5);
title(mat2str(H(signalThree,:)));
grid on;

% for i=2:4
%     subplot(6,1,i)
%     plot(t,signals(i,:),'LineWidth',1.5);
%     title(mat2str(H(i,:)));
%     grid on;
% end

% 4 Prueba de ortoganilidad
% Lineas de prueba tomadas del punto anterior
% Funcion que realiza la prueba e imprime el resultado
testLines=[H(signalOne,:); H(signalTwo,:); H(signalThree,:)];
usuarioOne=ProbarOtogonalidad(H, testLines(1,:));
usuarioTwo=ProbarOtogonalidad(H, testLines(2,:));
usuarioThree=ProbarOtogonalidad(H, testLines(3,:));

%% 4 Armado de trama y Simulacion QPSK
% Servicio|Proveedor|CellId?|usuario
usuarioModular=input('Cúal de los usuarios mostrados quieres modular(1,2,3)?');
switch usuarioModular
    case 1
        trama=[servicio prov.CodigoNZR testLines(1,:)];
    case 2
        trama=[servicio prov.CodigoNZR testLines(2,:)];
    case 3
        trama=[servicio prov.CodigoNZR -1 1 testLines(3,:)];
end

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
title('Trama modulada QPSK');

subplot(6,1,5);
stairs(0:length(trama), [trama trama(24)],'linewidth',1.5);
grid on;
title('Trama servicio|proveedor|nodo|usuario');


%% 
% usuario=de2bi(5,8,'left-msb')*2-1;
% trama=[servicio tramaPorveedorNrz usuario];
% 
% s_p_data=reshape(trama,2,length(trama)/2);
% br=10.^6;
% f=br;
% T=1/br;
% t=T/99:T/99:T;
% y=[];
% y_in=[];
% y_qd=[];
% 
% for(i=1:length(trama)/2)
%     y1=s_p_data(1,i)*cos(2*pi*f*t); % inphase component
%     y2=s_p_data(2,i)*sin(2*pi*f*t) ;% Quadrature component
%     y_in=[y_in y1]; % inphase signal vector
%     y_qd=[y_qd y2]; %quadrature signal vector
%     y=[y y1+y2]; % modulated signal vector
% end
% Tx_sig=y;
% tt=T/99:T/99:(T*length(trama))/2;
% subplot(6,1,6);
% plot(tt,Tx_sig,'linewidth',1.5),
% grid on;
% title('Codigo modulado QPSK');
% 
% subplot(6,1,5);
% stairs(0:length(trama), [trama 1],'linewidth',1.5);
% grid on;
% title('Trama codififcada');
