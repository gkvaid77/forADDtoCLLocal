function sig=CalculateModPhase(tOut,in,out,sineA,sinef,ind_start,ind_end)

sig.in=in;
sig.out=out;

for i= 1:length(sineA) 

    ts = ind_start(i)/5-0.5*200;
    te = ind_end(i)/5+1*200;
    sig_in = sig.in(ts:te);
    sig_out = sig.out(ts:te);
    TF = tOut(ts:te);

    imax = islocalmax(sig_in,'MinProminence',sineA(i)*0.5);
    imax_i = find(imax==1);
    imin = islocalmin(sig_in,'MinProminence',sineA(i)*0.5);
    imin_i = find(imin==1);

    imax = islocalmax(sig_out,'MinProminence',sineA(i)*0.05,'FlatSelection','first','MinSeparation',1/sinef(i)/2*200);
    imax_o = find(imax==1);
    imin = islocalmin(sig_out,'MinProminence',sineA(i)*0.05,'FlatSelection','first','MinSeparation',1/sinef(i)/2*200);
    imin_o = find(imin==1);

    %     % Computing Amplitude
    if (length(sig_out(imax_o))==(length(sig_out(imin_o))+1))
        amp(i) = (mean(sig_out(imax_o(1:end-1))-sig_out(imin_o)))/2;
        sig.mag(i) = amp(i)/sineA(i)/9.81;
    elseif (length(sig_out(imax_o))~=(length(sig_out(imin_o))+1))
        amp(i) = (mean(sig_out(imax_o(2:7))-sig_out(imin_o(2:7))))/2;
        sig.mag(i) = amp(i)/sineA(i)/9.81;
    else
        amp(i)=NaN;
        sig.mag(i) =NaN;
        mag_NaN_count = mag_NaN_count +1;
    end
    %     Computing Phase;
    if (length(sig_out(imax_o))==length(sig_out(imax_i))) && length(sig_out(imin_o))==length(sig_out(imin_i))
        delta_t1 = TF(imax_o) - TF(imax_i);
        delta_t2=  TF(imin_o) - TF(imin_i);
        delta_t = [delta_t1;delta_t2];
        sig.delay(i) = mean(delta_t);
        sig.phase(i) = sig.delay(i)*sinef(i)*360;
    elseif (length(sig_out(imax_o))==length(sig_out(imax_i))) && length(sig_out(imin_o))~=length(sig_out(imin_i))
        delta_t1 = TF(imax_o) - TF(imax_i) ;
        delta_t2=  TF(imin_o(2:7)) - TF(imin_i(2:7));
        delta_t = [delta_t1;delta_t2];
        sig.delay(i) = mean(delta_t);
        sig.phase(i) = sig.delay(i)*sinef(i)*360;
    elseif (length(sig_out(imax_o))~=length(sig_out(imax_i))) && length(sig_out(imin_o))==length(sig_out(imin_i))
        delta_t1 = TF(imax_o(2:7)) - TF(imax_i(2:7)) ;
        delta_t2=  TF(imin_o) - TF(imin_i);
        delta_t = [delta_t1;delta_t2];
        sig.delay(i) = mean(delta_t);
        sig.phase(i) = sig.delay(i)*sinef(i)*360;
    elseif ((length(sig_out(imax_o))~=length(sig_out(imax_i))) && length(sig_out(imin_o))~=length(sig_out(imin_i)))
        delta_t1 = TF(imax_o(2:7)) - TF(imax_i(2:7)) ;
        delta_t2=  TF(imin_o(2:7)) - TF(imin_i(2:7));
        delta_t = [delta_t1;delta_t2];
        sig.delay(i) = mean(delta_t);
        sig.phase(i) = sig.delay(i)*sinef(i)*360;
    else
        sig.delay(i)=NaN;
        sig.phase(i)=NaN;
        phase_NaN_count = phase_NaN_count+1;
    end

    clear ts te sig_in sig_out imax_i imax_o imin_o imin_i


end

figure()
plot(sinef(1:i),sig.phase(1:i),'*')
ylabel('phase lag')
xlabel('Frequency [Hz]')
title('phase lag[°]')
grid on
figure()
plot(sinef(1:i),sig.delay(1:i),'*')
ylabel('delay[s]')
xlabel('Frequency [Hz]')
title('delay')
grid on
figure()
plot(sinef(1:i),sig.mag(1:i),'*')
ylabel('Mag')
xlabel('Frequency [Hz]')
title('Magnitude')
grid on

%This line is added for commit1
%This line is added after linking to remote repository "forADDtoCLLocal"

end