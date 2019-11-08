function [usuarioIdentificado] = ProbarOtogonalidad(H, test)
    esOrtogonal=1;
    for j=1:length(H)
        %disp(strcat('[',num2str(test),']','.','[',num2str(H(j,:)),']','=',num2str(dot(test,H(j,:))),' ','usuario',num2str(j)))
        if(dot(test,H(j,:))~=0)
            if(test~=H(j,:))
                esOrtogonal=0;
            end
            
            usuarioIdentificado=j;
        end
    end
    
    if(esOrtogonal==1)
        disp(strcat('Es ortogonal y el usuario identificado es: ', num2str(usuarioIdentificado)));
    else
        disp('No es ortogonal');
    end

%     esOrtogonal=1;
%     for i=1:size(testLines,1)
%         testLine=testLines(i,:);
% 
%         for j=1:16
%             if(dot(testLine,H(j,:))~=0)
%                 if(testLine==H(j,:))
%                     esOrtogonal=0;
%                 end
%                 usuarioIdentificados=[usuarioIdentificados j];
%             end
%         end
%     end
% 
%     if(esOrtogonal==1)
%         disp(strcat('Es ortogonal y los usuarios identificados son: '), usuarioIdentificados);
%     else
%         disp('No es ortogonal');
%     end
end

