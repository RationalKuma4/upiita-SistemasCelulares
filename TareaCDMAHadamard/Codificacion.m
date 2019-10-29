function [codigo] = Codificacion(servicio, proveedor, usuario)
    codigo=[];
    if(strcmp(servicio,'watt')==1)
        codigo=[codigo 0];
    elseif(strcmp(servicio,'face')==1)
        codigo=[codigo 1];
    end
    
    if(proveedor==1)
        codigo=[codigo 0];
    elseif(proveedor==3)
        codigo=[codigo 1];
    end
    % xmubin=de2bi(xmu,'left-msb');
end

