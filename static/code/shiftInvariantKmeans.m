function [label,V,pseudoF] = shiftInvariantKmeans(X,K,xcorr_type)
%1-D shift and amplitude invariant k-means with kmeans++ initialization
%distance are computed on the sphere
%implements phase and sign invariance also
%--------------
% Inputs:
%--------------
% X [matrix] waveform matrix of which each column is a shift-invariant waveform
% K [scalar] number of clusters
% xcorr_type [string: eith 'abs','hilbert', or ''] designating phase or polarity
%               invariance
%--------------
% Outputs:
%--------------
% label [vector] cluster label assignment for each input waveform
% V     [matrix] cluster centroids, each colum is a waveform, may have less than K columns
% pseudoF [scalar] the pseudo Fscore (Calinski-Harabasz?s criterion)
%--------------
%References:
%--------------
% D. Charalampidis, ?A modified k-means algorithm for circular invariant
%  clustering,? IEEE Trans. Pattern Anal. Mach. Intell., vol. 27, no. 12, pp.
%  1856?1865, 2005.
% T.Calinski and J. Harabasz, ?A dendrite method for cluster analysis,?
%  Commun. Stat.-Theory, vol. 3, no. 1, pp. 1?27, 1974.
%
% copyright Austin J. Brockmeier (2015-2016) ajbrockmeier@gmail.com
% This is version 1.0 , please let me know of bugs
if nargin<3
    xcorr_type='';%allow polarity or phase invariance
end
[N,n]=size(X);% there are n waveforms of length N
if N<=1
    error('Empty or scalar given for waveform matrix\n')
end
if ~isscalar(K) || round(K)~=K || K<1
    error('the number of clusters (K) should be an positive integer\n')
end
X=bsxfun(@rdivide,X,sqrt(sum(X.^2)));% normalized by 2-norm
if n==1
    label=1;
    V=X;
    pseudoF=nan;
    return;
end

X2=cat(1,zeros(N-1,n),X,zeros(N-1,n));
fX=fft(X2);
XcorrWithX=@(y) getXcorr(fX,y,N,xcorr_type);
c_index=zeros(1,K);
c_index(1)=min(1,ceil(rand()*n));
for k=2:K
    D2=eps+2-2*max(XcorrWithX(X(:,c_index(1:k-1))),[],2);
    if sum(D2)==0
        p=ones(n,1);
    else
        p=D2/sum(D2);
    end
    c_index(k)=find(rand(1)<=cumsum(p),1,'first');
end
c_index=unique(c_index);
if numel(c_index)<K
   K=numel(c_index);
   fprintf('Starting with %i centers\n',K);
end
V=X(:,c_index);
%get rid of redundant centers
redundant_threshold=.001;
Dist=myXcorrDist(V,xcorr_type);
Dist(1:1+K:end)=inf;
idx=find(Dist<redundant_threshold,1);
while ~isempty(idx)%remove redundant waveforms
    [row,~]=ind2sub([K,K],idx);
    V(:,row)=0;
    Dist(row,:)=inf;
    Dist(:,row)=inf;
    idx=find(Dist<redundant_threshold,1);
end
V=V(:,sum(abs(V))>0);
label=zeros(n,1);

for iter=0:100*log(n)+1
    oldlabel=label;
    [C,Lags,Signs]=XcorrWithX(V);
    [~,label]=max(C,[],2);
    [un_lab,~,label]=unique(label);
    V=V(:,un_lab);
    Lags=Lags(:,un_lab);
    Signs=Signs(:,un_lab);
    K=numel(un_lab);
    lag=sum(Lags.*bsxfun(@eq,label,1:K),2);
    lag_index=sub2ind(size(X2),lag'+N,1:n);
    XX=X2(bsxfun(@plus,lag_index,(0:N-1)'));
    if ~all(Signs==1)
        wave_phase=sum(Signs.*bsxfun(@eq,label,1:K),2)';
        XX=real(bsxfun(@times,XX,wave_phase));
    end
    for k=1:K
        XX_k=XX(:,label==k);
        %solve V_k
        v_k=mean(XX_k,2);
        V(:,k)=v_k/sqrt(sum(v_k.^2));
    end
    if  all(oldlabel==label) || all(label==label(1))
        break;
    else
        fprintf('%i\n',iter)
    end
end
fprintf('Finished with %i centers after %i iterations\n',K,iter)
if nargout>2
    if K>1
        [~,V1] = shiftInvariantKmeans(X,1 );
        total_distortion=sum(XcorrWithX(V1));
        for K=1:max_clusters
            n_per_cluster=zeros(1,K);
            within_cluster=0;
            for k=1:K
                match_idx=label==k;
                n_per_cluster(k)=sum(match_idx);
                temp=XcorrWithX(V(:,k));
                within_cluster=within_cluster+sum(temp(match_idx));
            end
            between_cluster=total_distortion-within_cluster;
            pseudoF=(n-K)/(K-1)*between_cluster/within_cluster;
        end
    else
        pseudoF=nan;
    end
end
end


function [C,Lags,S]=getXcorr(fX,Y,N,method)
%stripped down version of fasterXcorr2 that uses precomputed FFT
[M,m]=size(fX);
[~,m2]=size(Y);
switch method
    case 'abs'
        f_func=@(x) abs(x);
        sign_func=@(x) sign(x);
    case {'hilbert','phase'}
        f_func=@(x) abs(x);
        Y=hilbert(Y);
        sign_func=@(x) exp(-1j*atan2(imag(x),real(x)));
    otherwise
        f_func=@(x) x;
        sign_func=@(x) ones(size(x));
end
Y2=cat(1,zeros(N-1,m2),Y,zeros(N-1,m2));
fY=fft(flipud(Y2));


P=floor(M/2);
block_size=50;
C=zeros(m,m2);
S=zeros(m,m2);

Lags=zeros(m,m2);
for col=1:m
    for rowstart=1:block_size:m2
        rows=rowstart:min(rowstart+block_size-1,m2);
        H=bsxfun(@times,fX(:,col),fY(:,rows));
        val=ifft(H);
        [maxval,lag_idx]=max(f_func(val),[],1);
        lag=(lag_idx<=P).*lag_idx+(lag_idx>P).*(lag_idx-2*P-mod(M,2));
        C(col,rows)=maxval;
        S(col,rows)=sign_func(val(sub2ind(size(val),lag_idx(:)',1:size(val,2))));
        Lags(col,rows)=lag;
    end
end
end



function D=myXcorrDist(X,method)
[n,m]=size(X);
X=bsxfun(@rdivide,X,sqrt(sum(X.^2)));
X2=cat(1,zeros(n-1,m),X,zeros(n-1,m));
fX2=fft(X2);
if 1~=strcmp(method,'hilbert')
    ufX2=fft(flipud(X2));
else
    ufX2=fft(flipud(hilbert(X2)));
end

block_size=50;
pdistout=zeros(m*(m-1)/2,1);
ii=0;
for col=1:m-1
    for rowstart=col+1:block_size:m
        rows=rowstart:min(rowstart+block_size-1,m);
        H=bsxfun(@times,ufX2(:,col),fX2(:,rows));
        val=ifft(H);
        switch method
            case {'abs','hilbert'}
                val=abs(val);
            otherwise
        end
        val=max(val,[],1);
        pdistout(ii+(1:numel(rows)))=1-val;
        ii=ii+numel(rows);
    end
end
D=squareform(pdistout);
D(1:m+1:end)=1-sum(X.^2);
end