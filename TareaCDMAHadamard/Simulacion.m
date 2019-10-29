clc;
clear all;
close all;
%% Codificacion
% aplicacion=input('Aplicacion-> 0-Whatsapp, 1-Facebook: ');
proveedor=input('Proveedor-> 1-Telcel, 2-Movistar, 3-AT&T, 4-I-U: ');
usuario=input('Numero de usuario: ');

trama=[];
tramaProveedor=[1];
if(proveedor==1)
    tramaProveedor=[tramaProveedor 1 1];
    tramaProveedor=[tramaProveedor 0 0];
    tramaProveedor=[tramaProveedor 0 1];
elseif(proveedor==2)
    tramaProveedor=[tramaProveedor 1 1];
    tramaProveedor=[tramaProveedor 0 0];
    tramaProveedor=[tramaProveedor ];
elseif(proveedor==3)
    tramaProveedor=[-1];
    tramaProveedor=[tramaProveedor 1 1];
    tramaProveedor=[tramaProveedor 0 0];
    tramaProveedor=[tramaProveedor 0 1];
elseif(proveedor==4)
    tramaProveedor=[tramaProveedor 1 1];
    tramaProveedor=[tramaProveedor 0 0];
    tramaProveedor=[tramaProveedor 0 1];
end

trama=[tramaProveedor];

tramaUsuario=[];
charArray=num2str(usuario)-'0';
if(length(charArray)==3)
    tramaUsuario=[tramaUsuario de2bi(charArray(1),3,'left-msb')];
    tramaUsuario=[tramaUsuario de2bi(charArray(2),4,'left-msb')];
    tramaUsuario=[tramaUsuario de2bi(charArray(3),4,'left-msb')];
elseif(length(charArray)==3)
    tramaUsuario=[tramaUsuario 0 0];
    tramaUsuario=[tramaUsuario de2bi(charArray(1),4,'left-msb')];
    tramaUsuario=[tramaUsuario de2bi(charArray(2),4,'left-msb')];
elseif(length(charArray)==3)
    tramaUsuario=[tramaUsuario 0 0 0 0 0 0];
    tramaUsuario=[tramaUsuario de2bi(charArray(1),4,'left-msb')];
end
trama=[trama tramaUsuario];

H=hadamard(512);
esOrtogonal=1;
for i=1:512
    for j=1:512
        if(j~=i)
            orto=dot(H(i,:), H(j,:));
            if(orto~=0)
                esOrtogonal=0;
                break;
            end
        end
    end
end

trama=[trama H(usuario,:) 0];
trama(trama==0)=-1;

figure(1);
subplot(3,1,1);
ss=0:1:length(trama)-1;
stairs(ss,trama);
title('');
ylim([-1.5 1.5]); 
xlim([0 length(trama)-1/2]); 
grid on;

%% Codificacion en tiempo
t = 0:0.02:12;
f=.5;
x=sin(2*pi*f*t);

% Rectificar señal
x(x<0) = x(x<0)*-1;

signals=zeros(520,601);
signalOne=zeros(1,601);
for j=1:1%length(trama(1,:))
    factor=trama(j,:);
    
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
    end
    
    signals(j,:)=signalOne;
end

subplot(3,1,2);
plot(t,signals(1,:),'LineWidth',1.5);
grid on;

%% Modulacion QPSK
% H(H<0) = 0;
% data=H(512,:);
% 
% data_NZR=2*data-1; % Datos representados en NZR
s_p_data=reshape(trama,2,length(trama)/2);  % S/P convertion of data
br=10.^6; %Let us transmission bit rate  1000000
f=br; % minimum carrier frequency
T=1/br; % bit duration
t=T/99:T/99:T; % Time vector for one bit information

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

subplot(3,1,3);
plot(tt,Tx_sig,'linewidth',1), 
grid on;


