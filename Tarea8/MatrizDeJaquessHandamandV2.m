clear;
clc;
close all;
usrs=16;
for num_rep=1:3
   
    disp(['<<<<< Te encuentras situado en el punto ', num2str(num_rep), ' de la tarea anterior >>>>>'])
    frame=[];

    disp('=== DATOS ===');
    w=0;
    while w==0
        selec=input('ID de usuario a desplegar (1-16): ');
        if selec >0 && selec < usrs+1 && num_rep == 1
            w=1;
        
        elseif num_rep == 2 && selec ~= mmm(1) && selec >0 && selec < usrs+1
            w=1;
        
        
        elseif num_rep == 3 && selec ~= mmm(2) && selec ~= mmm(1) && selec >0 && selec < usrs+1
            w=1;
        end

    end
    
    mmm(num_rep)=selec;
    
    w=0;
    while w==0
        telefonica=input('Telefonica (1 Telcel, 2 Movistar, 3 AT&T, 4 Iusacell-Unefon ): ');
        if telefonica < 5 && telefonica > 0
            w=1;
        end
    end

    if telefonica==1
        frame=[-1 -1];
    elseif telefonica==2
        frame=[-1 1];
    elseif telefonica==3
        frame=[1 -1];
    else 
        frame=[1 1];
    end

    w=0;
    while w==0
        servicio=input('Servicio (0 Whatsapp, 1 Facebook): ');
        if servicio < 2 && servicio > -1
            w=1;
        end
    end

    if servicio==1
        frame=[frame 1];
    else
        frame=[frame -1];
    end


    w=0;
    while w==0
        dato=input('Dato (1 A, 2 B, 3 C, 4 D, 5 E, 6 F, 7 G, 8 H) ');
        if dato < 9 && dato > 0
            w=1;
        end
    end

    if dato == 1
        frame=[frame -1 -1 -1];
    elseif dato == 2
        frame=[frame -1 -1 1];
    elseif dato == 3
        frame=[frame -1 1 -1];
    elseif dato == 4
        frame=[frame -1 1 1];
    elseif dato == 5
        frame=[frame 1 -1 -1];
    elseif dato == 6
        frame=[frame 1 -1 1];
    elseif dato == 7
        frame=[frame 1 1 -1];
    else 
        frame=[frame 1 1 1];
    end

if num_rep == 1 && (telefonica == 1 || telefonica == 2)
        frame=[frame -1 -1];
        
    elseif num_rep == 1 && (telefonica == 3 || telefonica == 4)
        frame=[frame 1 -1];
        
    elseif num_rep == 2 && (telefonica == 1 || telefonica == 2)
        frame=[frame -1 -1];
        
    elseif num_rep == 2 && (telefonica == 3 || telefonica == 4)
        frame=[frame -1  1];
       
    elseif num_rep == 3 && (telefonica == 1 || telefonica == 2)
        frame=[frame -1 -1];
        
    else 
        frame=[frame 1 -1];
        
    end
    
    br=1900*10.^6; % Rango de bit 
    f=br; % Frecuencia
    T=1/br; %  Tiempo de bit
    t=T/10:T/10:T; % Vector para un bit de duración

    ID_usr=hadamard(usrs);

    [a,b]=size(ID_usr);

    k=0;
    for i=1:a
        for j=1:b

            if i==j

            else
                Orto= sum(ID_usr (i,:).*ID_usr(j,:));
                mensaje=['Multiplicación del vector ', num2str(i), ' y ', num2str(j), ' igual a ', num2str(Orto), ' -> ', mat2str(ID_usr (i,:)), ' * ', mat2str(ID_usr(j,:)) ,' = ', num2str(Orto)];
                disp(mensaje)
                if Orto ~= 0
                    k=k+1;
                end
            end

        end 
    end 
    disp('== ¿Es ortogonal? ==');
    if k==0
        disp('Si')
    else
        disp('No')
    end
    % length(frame)
    frame =[frame ID_usr(selec,:)];

    figure (num_rep);
    subplot(3,1,1); stairs([0:length(frame)],[frame frame(length(frame))]); ylim([-2 2]); xlim([0 length(frame)]); 
    title (['Trama generada ', mat2str(frame)]); xlabel('Num de bit'); ylabel('amplitud');
    hold on;

    ID_usr_2=reshape(frame,2,length(frame)/2); 

    vec_pulso=[];
    contador=1;

    for ss=1:length(frame)
        for s=1:5
            vec_pulso(contador)=frame(ss);
            contador=1+contador;
        end
    end

    y=[];
    y_in=[];
    y_qd=[];
    for(i=1:length(frame)/2)
        y1=ID_usr_2(1,i)*cos(2*pi*f*t); % componente en fase
        y2=ID_usr_2(2,i)*sin(2*pi*f*t) ;% componente en cuadratura
        y_in=[y_in y1]; % vector en fase
        y_qd=[y_qd y2]; % vector en cuadratura 
        y=[y y1+y2]; % vector de señal modulada
    end

    Tx_sig=y; % Transmision
     tt=0:T/10:((T*length(frame))/2)-T/10;

    subplot(3,1,2); 
    stairs(tt, vec_pulso,'r'); hold on; 
    stairs(tt(1:11), vec_pulso(1:11),'b'); hold on; % compa 
    stairs(tt(11:16), vec_pulso(11:16),'k'); hold on; %ser
    stairs(tt(16:31), vec_pulso(16:31),'m');  hold on; %payload
    stairs(tt(31:41), vec_pulso(31:41),'g');  hold on; %nodob
    axis([0 (T*length(frame))/2  -2 2])
    title ('Trama de usuario en tiempo'); xlabel('tiempo (s)'); ylabel('amplitud');  
    legend('Usuario', 'Compania', 'Servicio', 'Payload','Nodo B');
   
    
    subplot(3,1,3); 
    plot(tt, y/max(y),'r'); ylim([-2 2]); hold on; 
    plot(tt(1:11), y(1:11)/max(y),'b'); hold on; % compa
    plot(tt(11:16), y(11:16)/max(y),'k');   hold on; %ser
    plot(tt(16:31), y(16:31)/max(y),'m'); hold on; %payload
    plot(tt(31:41), y(31:41)/max(y),'g');  hold on; %nodob
    axis([0 (T*length(frame))/2  -2 2])
    title ('Trama de usuario en tiempo modulada en QPSK'); xlabel('tiempo (s)'); ylabel('amplitud'); 
     
    legend('Usuario', 'Compania', 'Servicio', 'Payload','Nodo B');
     
    % Rx_rec=[];
    % Rx_sig=Tx_sig; % Received signal
    % for(i=1:1:(usrs)/2)
    %     %XXXXXX inphase coherent dector XXXXXXX
    %     Z_in=Rx_sig((i-1)*length(t)+1:i*length(t)).*cos(2*pi*f*t); 
    %     above line indicat multiplication of received & inphase carred signal
    %     
    %     Z_in_intg=(trapz(t,Z_in))*(2/T);% integration using trapizodial rull
    %     if(Z_in_intg>0) % Decession Maker
    %         Rx_in_data=1;
    %     else
    %        Rx_in_data=0; 
    %     end
    %     
    %     %Detector coherente de cuadratura
    %     Z_qd=Rx_sig((i-1)*length(t)+1:i*length(t)).*sin(2*pi*f*t);
    %     %Obtención de cuadratura
    %     
    %     Z_qd_intg=(trapz(t,Z_qd))*(2/T);
    %         if (Z_qd_intg>0)% Marcador de dec,
    %         Rx_qd_data=1;
    %         else
    %         Rx_qd_data=0; 
    %         end
    %         Rx_rec=[Rx_rec  Rx_in_data  Rx_qd_data]; % Vector rec
    % end
    % 
    % figure(2)
    % Rx_NRZ= Rx_rec*2-1;
    % plot([0:length(Rx_NRZ)-1],Rx_NRZ,'m'); hold on;
    % plot([0:1],Rx_NRZ(1:2),'r'); hold on;
    % plot([2],Rx_NRZ(3),'y'); hold on;
    % plot([3:5],Rx_NRZ(4:6),'g'); hold on;
    % plot([6:length(Rx_NRZ)-1],Rx_NRZ(7:length(Rx_NRZ)),'k'); hold on;
    % legend('Cabercera','holis','crayolis','pistolis','vaquita');
    % ylim([-2 2]); xlim([0 length(frame)-1]);

    disp('=== DATOS ===');
    % Obteniendo datos
    if frame (1:2) == [ -1 -1]
        disp('Compania Celular: Telcel');
        disp('ID Compania Celular: 334020');
    elseif frame (1:2) == [ -1 1]
        disp('Telefonia: Movistar');
        disp('ID Telefonia: 334030');
    elseif frame (1:2) == [ 1 -1]
        disp('Telefonia: AT&T');
        disp('ID Telefonia: 310410');
    else 
        disp('Telefonia: Iusacell-Unefon');
        disp('ID Telefonia: 384050');
    end

    if frame (3) == 1
        disp('Servicio: Facebook');
    else
        disp('Servicio: Whatsapp');
    end

    if frame(4:6)== [-1 -1 -1]
        disp('Dato: A');
    elseif frame(4:6)== [-1 -1 1]
        disp('Dato: B');
    elseif frame(4:6)== [-1 1 -1]
        disp('Dato: C');
    elseif frame(4:6)== [-1 1 1]
        disp('Dato: D');
    elseif frame(4:6)== [1 -1 -1]
        disp('Dato: E');
    elseif frame(4:6)== [1 -1 1]
        disp('Dato: F');
    elseif frame(4:6)== [1 1 -1]
        disp('Dato: G');
    else
        disp('Dato: H');
    end
    
    if num_rep == 1 && (telefonica == 1 || telefonica == 2)
        disp('Nodo_B: 1');
        disp('Potencia de recepcion: -38.1418 dBm');
    elseif num_rep == 1 && (telefonica == 3 || telefonica == 4)
        disp('Nodo_B: 3');
        disp('Potencia de recepcion: -32.1418 dBm');
    elseif num_rep == 2 && (telefonica == 1 || telefonica == 2)
        disp('Nodo_B: 1');
        disp('Potencia de recepcion: -43.200 dBm');
    elseif num_rep == 2 && (telefonica == 3 || telefonica == 4)
        disp('Nodo_B: 2');
        disp('Potencia de recepcion: -41.977 dBm');
    
    elseif num_rep == 3 && (telefonica == 1 || telefonica == 2)
        disp('Nodo_B: 1');
        disp('Potencia de recepcion: -36.021 dBm');
    else 
        disp('Nodo_B: 3');
        disp('Potencia de recepcion: -43.877 dBm');
    end
    
    
    

    for r=1:usrs
         if ID_usr (r,:)== frame(9:length(frame))
            disp(['ID Usuario: ',num2str(r)]);
        end
    end
    w=0;
end