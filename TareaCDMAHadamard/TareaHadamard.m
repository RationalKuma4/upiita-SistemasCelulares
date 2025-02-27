clc;
clear all;
close all;

%% Condiciones iniciales
H = hadamard(512);
t = 0:0.02:12;
f=0.5;
x=sin(2*pi*f*t);
rr=300; % Renglon de interes

figure(1);
subplot(3,1,1);
xs=0:1:511;
stairs(xs, H(rr,:),'LineWidth',1.5); 
ylim([-1.2 1.2]); 
xlim([0 12]);
title('Matriz Hadamard');
grid on;

% Rectificar se�al y se�al en tiempo
x(x<=0) = x(x<=0)*-1;
signals=zeros(512,601);
signalOne=zeros(1,601);

for j=1:length(H(1,:))
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
    end
    
    signals(j,:)=signalOne;
end

subplot(3,1,2);
plot(t,signals(rr,:),'LineWidth',1.5);
ylim([-1.2 1.2]); 
xlim([0 12]);
title('Matriz Hadamard en tiempo');
grid on;

%% QPSK
data=H(rr,:);
% data_NZR=2*data-1; % Datos representados en NZR
s_p_data=reshape(data,2,length(data)/2); 
%br=10.^6; 
%f=br; 
T=1/f;
t=T/99:T/99:T; 

y=[];
y_in=[];
y_qd=[];
for(i=1:length(data)/2)
    y1=s_p_data(1,i)*cos(2*pi*f*t); % inphase component
    y2=s_p_data(2,i)*sin(2*pi*f*t) ;% Quadrature component
    y_in=[y_in y1]; % inphase signal vector
    y_qd=[y_qd y2]; %quadrature signal vector
    y=[y y1+y2]; % modulated signal vector
end
Tx_sig=y; 
tt=T/99:T/99:(T*length(data))/2;

subplot(3,1,3);
plot(Tx_sig,'LineWidth',1.5);
ylim([-1.8 1.8]); 
xlim([0 800]);
title('Matriz Hadamard mouloado QPSK');
grid on;
