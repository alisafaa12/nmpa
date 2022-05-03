% 3-tier heteerogeneous network
% System parameters
% function PathLoss_BS_User= bs_user_distribution(x,Num_User,~)
function PathLoss_BS_User= bs_user_distribution()
%     Bandwidth = 10; %MHz
%     Noise = -124;   % dBm  -174dBm/Hz
    % Area: Square
    l=1;  % 1km* 1km
    % power limits
%     p_max = 20; %dBm
    % BSs
    Num_BS = 1;
    % Users
    global Num_User;
%     Num_User = 20;
%     Const = 10;
%     delta = 3*sqrt(5)/5;
    
    BS_loc = [.5; .5]*l;
    % User_loc = x'*l;
    User_loc = rand(2,Num_User)*l;

    Distance_BS_User = max(1000*sqrt(sum((repmat(BS_loc,1,Num_User)-User_loc).^2)),0.001);
    PathLoss_BS_User = 128.1+37.6*log(Distance_BS_User(1,:)/1000)/log(10)-20;
    % PathLoss_BS_User = 60+40*rand(1,Num_User);
    PathLoss_BS_User = sort(PathLoss_BS_User,'descend');
%     % Date save
%     save('SystemData2.mat','p_max','Num_BS','BS_loc','Num_User','User_loc','PathLoss_BS_User',...
%         'Bandwidth','Noise','p_max','Const','delta');
end