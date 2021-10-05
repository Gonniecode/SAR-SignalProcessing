clc
clear
close all
%% ��������
%  ��֪����--�����������
R_eta_c = 20e+3;                % ������б��
Tr = 2.5e-6;                    % ��������ʱ��
Kr = 20e+12;                    % �������Ƶ��
alpha_os_r = 1.2;               % �����������
Nrg = 320;                      % �����߲�������
%  �������--�����������
Bw = abs(Kr)*Tr;                % �����źŴ���
Fr = alpha_os_r*Bw;             % �����������
Nr = round(Fr*Tr);              % �����������(�������г���)
%  ��֪����--����λ�����
c = 3e+8;                       % ��Ŵ����ٶ�
Vr = 150;                       % ��Ч�״��ٶ�
Vs = Vr;                        % ����ƽ̨�ٶ�
Vg = Vr;                        % ����ɨ���ٶ�
f0 = 5.3e+9;                    % �״﹤��Ƶ��
Delta_f_dop = 80;               % �����մ���
alpha_os_a = 1.25;              % ��λ��������
Naz = 256;                      % ��������
theta_r_c = [+3.5,+21.9]*pi/180;% ����б�ӽ�
t_eta_c = [-8.1,-49.7];         % �����Ĳ������Ĵ�Խʱ��
%{
t_eta_c = -R_eta_c*sin(theta_r_c(2))/Vr
%}
f_eta_c = [+320,+1975];         % ����������Ƶ��
%{
f_eta_c = 2*Vr*sin(theta_r_c(1))/lambda
%}
%  �������--����λ�����
lambda = c/f0;                  % �״﹤������
La = 0.886*2*Vs*cos(theta_r_c(1))/Delta_f_dop;               
                                % ʵ�����߳���
Fa = alpha_os_a*Delta_f_dop;    % ��λ�������
Ta = 0.886*lambda*R_eta_c/(La*Vg*cos(theta_r_c(1)));
                                % Ŀ������ʱ��
R0 = R_eta_c*cos(theta_r_c(1)); % ���������б��
Ka = 2*Vr^2*cos(theta_r_c(1))^2/lambda/R0;              
                                % ��λ���Ƶ��
theta_bw = 0.886*lambda/La;     % ��λ��3dB�������
%  ��������
rho_r = c/(2*Fr);               % ������ֱ���
rho_a = La/2;                   % ������ֱ���
Trg = Nrg/Fr;                   % ��������ʱ��
Taz = Naz/Fa;                   % Ŀ������ʱ��
d_t_tau = 1/Fr;                 % �������ʱ����
d_t_eta = 1/Fa;                 % ��λ����ʱ����
d_f_tau = Fr/Nrg;               % �������Ƶ�ʼ��    
d_f_eta = Fa/Naz;               % ��λ����Ƶ�ʼ��
%% Ŀ������
%  ����Ŀ�������ھ�����֮��ľ���
A_r =   0; A_a =   0;                                   % A��λ��
B_r = -50; B_a = -50;                                   % B��λ��
C_r = -50; C_a = +50;                                   % C��λ��
D_r = +50; D_a = C_a + (D_r-C_r)*tan(theta_r_c(1));     % D��λ��
%  �õ�Ŀ�������ھ����ĵ�λ������
A_x = R0 + A_r; A_Y = A_a;                              % A������
B_x = R0 + B_r; B_Y = B_a;                              % B������
C_x = R0 + C_r; C_Y = C_a;                              % C������
D_x = R0 + D_r; D_Y = D_a;                              % D������
NPosition = [A_x,A_Y;
             B_x,B_Y;
             C_x,C_Y;
             D_x,D_Y;];                                 % ��������
fprintf( 'A������Ϊ[%+3.3f��%+3.3f]km\n', NPosition(1,1)/1e3, NPosition(1,2)/1e3 );
fprintf( 'B������Ϊ[%+3.3f��%+3.3f]km\n', NPosition(2,1)/1e3, NPosition(2,2)/1e3 );
fprintf( 'C������Ϊ[%+3.3f��%+3.3f]km\n', NPosition(3,1)/1e3, NPosition(3,2)/1e3 );
fprintf( 'D������Ϊ[%+3.3f��%+3.3f]km\n', NPosition(4,1)/1e3, NPosition(4,2)/1e3 );
%  �õ�Ŀ���Ĳ������Ĵ�Խʱ��
Ntarget = 4;
Tar_t_eta_c = zeros(1,Ntarget);
for i = 1 : Ntarget
    DeltaX = NPosition(i,2) - NPosition(i,1)*tan(theta_r_c(1));
    Tar_t_eta_c(i) = DeltaX/Vs;
end
%  �õ�Ŀ���ľ����������ʱ��
Tar_t_eta_o = zeros(1,Ntarget);
for i = 1 : Ntarget
    Tar_t_eta_o(i) = NPosition(i,2)/Vr;
end
%% ��������
%  ʱ����� �Ծ����ĵ��������ʱ����Ϊ��λ�����
t_tau = (-Trg/2:d_t_tau:Trg/2-d_t_tau) + 2*R_eta_c/c;   % ����ʱ�����
t_eta = (-Taz/2:d_t_eta:Taz/2-d_t_eta) + t_eta_c(1);    % ��λʱ�����
%  ���ȱ���
r_tau = (t_tau*c/2)*cos(theta_r_c(1));                  % ���볤�ȱ���                                                     
%  Ƶ�ʱ��� 
f_tau = fftshift(-Fr/2:d_f_tau:Fr/2-d_f_tau);           % ����Ƶ�ʱ���
f_tau = f_tau - round((f_tau-0)/Fr)*Fr;                 % ����Ƶ�ʱ���(�ɹ۲�Ƶ��)                          
f_eta = fftshift(-Fa/2:d_f_eta:Fa/2-d_f_eta);           % ��λƵ�ʱ���
f_eta = f_eta - round((f_eta-f_eta_c(1))/Fa)*Fa;        % ��λƵ�ʱ���(�ɹ۲�Ƶ��)
%% ��������     
%  �Ծ���ʱ��ΪX�ᣬ��λʱ��ΪY��
[t_tauX,t_etaY] = meshgrid(t_tau,t_eta);                % ���þ���ʱ��-��λʱ���ά��������
%  �Ծ��볤��ΪX�ᣬ��λƵ��ΪY��                                                                                                            
[r_tauX,f_etaY] = meshgrid(r_tau,f_eta);                % ���þ���ʱ��-��λƵ���ά��������
%  �Ծ���Ƶ��ΪX�ᣬ��λƵ��ΪY��                                                                                                            
[f_tau_X,f_eta_Y] = meshgrid(f_tau,f_eta);              % ����Ƶ��ʱ��-��λƵ���ά��������
%% �ź�����--��ԭʼ�ز��ź�  
tic
wait_title = waitbar(0,'��ʼ�����״�ԭʼ�ز����� ...');  
pause(1);
srt = zeros(Naz,Nrg);
for i = 1 : Ntarget
    %  ����Ŀ����˲ʱб��
    R_eta = sqrt( NPosition(i,1)^2 +...
                  Vr^2*(t_etaY-Tar_t_eta_o(i)).^2 );                      
    % ����ɢ��ϵ������
    A0 = [1,1,1,1]*exp(+1j*0);   
    % ���������
    wr = (abs(t_tauX-2*R_eta/c) <= Tr/2);                               
    % ��λ�����
    wa = sinc(0.886*atan(Vg*(t_etaY-Tar_t_eta_c(i))/NPosition(i,1))/theta_bw).^2;      
    %  �����źŵ���
    srt_tar = A0(i)*wr.*wa.*exp(-1j*4*pi*f0*R_eta/c)...
                          .*exp(+1j*pi*Kr*(t_tauX-2*R_eta/c).^2);                                                           
    srt = srt + srt_tar; 
    
    pause(0.001);
    Time_Trans   = Time_Transform(toc);
    Time_Disp    = Time_Display(Time_Trans);
    Display_Data = num2str(roundn(i/Ntarget*100,-1));
    Display_Str  = ['Computation Progress ... ',Display_Data,'%',' --- ',...
                    'Using Time: ',Time_Disp];
    waitbar(i/Ntarget,wait_title,Display_Str)
    
end
pause(1);
close(wait_title);
toc
%% �ź�����--��һ�ξ���ѹ��
%  ��������
dt = Tr/Nr;                                             % ����ʱ����
ttau = -Tr/2:dt:Tr/2-dt;                                % ����ʱ�����
%  �����˲���
%  �źű任-->��ʽһ���������壬ʱ�䷴�޺�ȡ���������DFT�õ�Ƶ��ƥ���˲���
%  �Ӵ�����
window_1 = kaiser(Nr,2.5)';                             % ʱ��
Window_1 = fftshift(window_1);                          % Ƶ��
hrt_1 = (abs(ttau)<=Tr/2).*exp(+1j*pi*Kr*ttau.^2);      % ��������
hrt_window_1 = Window_1.*hrt_1;                         % �Ӵ�
Hrf_1 = repmat(fft(conj(fliplr(hrt_window_1)),Nrg,2),[Naz,1]);                        
%  �źű任-->��ʽ�����������壬����DFT��ȡ������õ�Ƶ��ƥ���˲�����ʱ�䷴��
%  �Ӵ�����
window_2 = kaiser(Nr,2.5)';                             % ʱ��
Window_2 = fftshift(window_2);                          % Ƶ��
hrt_2 = (abs(ttau)<=Tr/2).*exp(+1j*pi*Kr*ttau.^2);      % ��������
hrt_window_2 = Window_2.*hrt_2;                         % �Ӵ�
Hrf_2 = repmat(conj(fft(hrt_window_2,Nrg,2)),[Naz,1]);                   
%  �źű任-->��ʽ������������Ƶ������ֱ����Ƶ������Ƶ��ƥ���˲���
%  �Ӵ�����
window_3 = kaiser(Nrg,2.5)';                            % ʱ��
Window_3 = fftshift(window_3);                          % Ƶ��
Hrf_3 = (abs(f_tau_X)<=Bw/2).*Window_3.*exp(+1j*pi*f_tau_X.^2/Kr);  
%  ƥ���˲�
Srf = fft(srt,Nrg,2);
Soutf_1 = Srf.*Hrf_1;
soutt_1 = ifft(Soutf_1,Nrg,2);
Soutf_2 = Srf.*Hrf_2;
soutt_2 = ifft(Soutf_2,Nrg,2);
Soutf_3 = Srf.*Hrf_3;
soutt_3 = ifft(Soutf_3,Nrg,2);
%% �ź�����--����λ����Ҷ�任
Srdf_1 = fft(soutt_1,Naz,1);
Srdf_2 = fft(soutt_2,Naz,1);
Srdf_3 = fft(soutt_3,Naz,1);
%% ��ͼ
H = figure();
set(H,'position',[50,50,600,900]); 
subplot(321),imagesc(real(Srdf_1)),set(gca,'YDir','normal')
%  axis([0 Naz,0 Nrg])
xlabel('����ʱ��(������)��'),ylabel('��λƵ��(������)��'),title('(a)ʵ��')
subplot(322),imagesc( abs(Srdf_1)),set(gca,'YDir','normal')
%  axis([0 Naz,0 Nrg])
xlabel('����ʱ��(������)��'),ylabel('��λƵ��(������)��'),title('(b)����')
%  sgtitle('ͼ6.5 ��λ����ٸ���Ҷ�任��ķ�����','Fontsize',16,'color','k')
subplot(323),imagesc(real(Srdf_2)),set(gca,'YDir','normal')
%  axis([0 Naz,0 Nrg])
xlabel('����ʱ��(������)��'),ylabel('��λƵ��(������)��'),title('(a)ʵ��')
subplot(324),imagesc( abs(Srdf_2)),set(gca,'YDir','normal')
%  axis([0 Naz,0 Nrg])
xlabel('����ʱ��(������)��'),ylabel('��λƵ��(������)��'),title('(b)����')
%  sgtitle('ͼ6.5 ��λ����ٸ���Ҷ�任��ķ�����','Fontsize',16,'color','k') 
subplot(325),imagesc(real(Srdf_3)),set(gca,'YDir','normal')
%  axis([0 Naz,0 Nrg])
xlabel('����ʱ��(������)��'),ylabel('��λƵ��(������)��'),title('(a)ʵ��')
subplot(326),imagesc( abs(Srdf_3)),set(gca,'YDir','normal')
%  axis([0 Naz,0 Nrg])
xlabel('����ʱ��(������)��'),ylabel('��λƵ��(������)��'),title('(b)����')
sgtitle('ͼ6.5 ��λ����ٸ���Ҷ�任��ķ�����','Fontsize',16,'color','k')