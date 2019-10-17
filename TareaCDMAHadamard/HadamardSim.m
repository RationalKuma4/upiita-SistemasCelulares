clear all;
close all;
clc;

H = hadamard(12);
t = 0:0.02:12;
f=.5;
x=sin(2*pi*f*t);

% Rectificar señal
x(x<0) = x(x>0)*1;

signals=zeros(12,601);
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

figure(1);
for i=1:6
    subplot(6,1,i)
    plot(t,signals(i,:));
    grid on;
end

figure(2);
for i=7:12
    subplot(6,1,i-6)
    plot(t,signals(i,:));
    grid on;
end

