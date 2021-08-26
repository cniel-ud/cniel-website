function eta = CAML_approx(X,labels,Q,logeta_init,Npos,niter)
% Copyright 2015 Austin J. Brockmeier
% ajbrockmeier at the domain of gmail.com

logbase=10;
Nbatch=Npos*2;
H=eye(Nbatch)-1/Nbatch;
d_x=size(X,2);

theta0=logeta_init*(ones(d_x,Q)+cat(2,zeros(d_x,1),(rand(d_x,Q-1)-.5)*.1));
for ii=1:niter
    m=randi(numel(labels),1);
    idx_pos=find(labels==labels(m) & (1:numel(labels))'~=m );
    idx_neg=find(labels~=labels(m));
    if numel(idx_pos)>0
        m_pos=idx_pos(randi(numel(idx_pos),Npos-1,1));
    else
        m_pos=m;
    end
    m_neg=idx_neg(randi(numel(idx_neg),Npos,1));
    XX=X([m;m_pos;m_neg],:);
    labs=labels([m;m_pos;m_neg]);
    L=bsxfun(@eq,labs,labs');
    [~,gradf]=sum_grad(theta0,XX,Nbatch,d_x,logbase,H*L*H);
    theta0=theta0-.01*gradf;
end
eta=reshape(logbase.^theta0,d_x,[]);

end


function [f, gradf]= sum_grad(logeta,X,N,d_x,logbase,Lc)

Xt1=kron(ones(N,1),X);
Xt2=kron(X,ones(N,1));
DD=bsxfun(@minus,Xt1,Xt2).^2;
eta=reshape(logbase.^logeta,d_x,[]);
Ks=exp(-DD*eta);
K=reshape(sum(Ks,2),N,N);
oN=ones(N,1);
avec=oN/N;
mu=K*avec;
Kc=bsxfun(@minus,bsxfun(@minus,K,mu),mu')+avec'*mu;

if any(isnan(K(:)))
    fprintf('whoa')
    f=NaN;
    gradf=0*logeta;
else
    trKL=oN'*(Kc.*Lc)*oN;%    trKL=trace(K*H*L*H);%where H is centering matrix
    trKK=oN'*(Kc.^2)*oN;%    trKK=trace(K*H*K*H);
    trLL=oN'*(Lc.^2)*oN;%    trLL=trace(L*H*L*H);
    
    Grad = (Lc*sqrt(trKK*trLL)-trKL*trLL*Kc*(trKK*trLL)^-.5)/(trKK*trLL);
    P = bsxfun(@times,Grad(:),Ks);
    gradf=real(P'*DD)'*log(logbase).*logbase.^logeta;
    f=-real(trKL/sqrt(trKK*trLL));
end

end


