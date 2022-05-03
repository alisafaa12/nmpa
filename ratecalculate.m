function rate = ratecalculate(power, PathLoss_BS_User, Num_User, Noise)
%
% This function is to caltulate the objective value of all the users
%
    rate = zeros(1,Num_User);
    for id_user = 1:Num_User
        rate(id_user) = log(1 + power(id_user)*PathLoss_BS_User(id_user)/(Noise + PathLoss_BS_User(id_user)*sum(power(id_user+1:end))));
    end
end