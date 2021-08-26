% A simple script to run the metric learning code
% Austin J. Brockmeier (2013-2015)
% ajbrockmeier at the domain of gmail.com

fprintf('Reminder to add minFunc to path\n');
fprintf('via addpath(genpath(...))\n');

%User defined parameters
Qs=[1 1];%number of kernels in the sum kernel when Q is greater than 1 this is a nonlinear kernel
run_approx=[1 0];%run CAML approx instead (useful when the number of sample is too big)
%approx has less storage but is much slower since 10000 iterations are run
if numel(Qs)~=numel(run_approx)%numel(Qs) should be equal to numel(run_approx)
    error('Please have same number of parameter choices\n');
end
%Classification paradigm
prop_test=1/3;
prop_valid=1/3;% this is currently unused (in the paper I use it to pick best neighborhood)
nmonte = 20;
Nrep=1; % number of replicate runs
knn=3;%neighborhood size for knn

for dataset={'Two Gaussians','4 Gaussians (XOR)'};
    % Dataset generation
    N=200;
    useful_dim=2;%only the first  dimensions are meaningful
    extra_dim=28;
    N1=round(N/2);
    N2=N-N1;
    switch dataset{1}
        case 'xor'
            all_labels=cat(1,ones(N1,1),-ones(N2,1));
            centers=[1 1; -1 -1; 1 -1; -1 1];
            vals=[1 -1];
            idx=cat(1,randi(2,N1,1),2+randi(2,N2,1));
            all_centers=cat(2,centers(idx,:),vals(randi(2,N,extra_dim)));
            X=.5*randn(N,useful_dim+extra_dim)+all_centers;
        otherwise
            all_labels=cat(1,ones(N1,1),-ones(N2,1));
            X=randn(N,useful_dim+extra_dim)+kron(all_labels, [ones(1,useful_dim) zeros(1,extra_dim)]);
    end
    P=size(X,2);
    N = size(X,1);
    X=bsxfun(@rdivide,X,sqrt(sum(X.^2)));%make variance constant!
    % %% precompute Euclidean distances
    DDall=zeros(N,N,P);
    for ii=1:P %calculate all of the distance matrices
        G=X(:,ii)*X(:,ii)';
        Di=-2*G+bsxfun(@plus,diag(G),diag(G)');
        DDall(:,:,ii)= Di;%reshape(Di,N*N,[]);
    end
    
    
    orig_results = zeros(nmonte,2);
    new_results = zeros(nmonte,2*numel(Qs));
    unit_weights=cell(nmonte,numel(Qs));
    
    Diso=sum(DDall,3);% original distances
    for mmm = 1:nmonte        
        %set up test and train partitions
        sortii=cell(2,1);
        N_keep=round(N*(1-prop_test-prop_valid));
        N_keep2=round(N*(1-prop_test));
        outoforder=randperm(N);
        sortii{1} = outoforder(1:N_keep);
        sortii{3} = outoforder(1+N_keep:N_keep2);
        sortii{2} = outoforder(1+N_keep2:end);
        
        labels=all_labels(sortii{1});
        test_labels=all_labels(sortii{2});
        cv_labels=all_labels(sortii{3});
        
        %Original distance
        [~,iii]=sort(Diso(sortii{1},sortii{2}));%un weighted original
        acc_1nn=mean(labels(iii(1,:))==test_labels); %1NN
        acc_knn=mean(mode(labels(iii(1:knn,:)))'==test_labels);%kNN
        orig_results(mmm,:)=[acc_1nn acc_knn];
        
        %CAML
        DD=reshape(DDall(sortii{1},sortii{1},:),numel(sortii{1})^2,[]);
        w_norm=mean(DD,1);% average squared distance
        DD=bsxfun(@rdivide,DD,w_norm);    %normalize distances
        arez=[];
        for qii=1:numel(Qs)
            Q=Qs(qii);
            if run_approx(qii)==1
            eta = CAML_approx(X(sortii{1},:),labels,Q,-1,4,10000);
            else
            eta = CAML(-1,DD,labels,Q);
            end
            w=bsxfun(@rdivide,eta,w_norm');%,[1 3 2]);
            %Compute new distance
            if Q==1
                Dnew=sqrt(sum(bsxfun(@times,DDall,permute(w,[3 2 1])),3));
            else
                Knew=reshape(sum(exp(-reshape(DDall(:,:,:),N^2,[])*w),2),N,N);
                K1=diag(Knew)*ones(1,size(Knew,1));
                Dnew = sqrt(-2*Knew+K1+K1');
            end
            [~,iii]=sort(Dnew(sortii{1},sortii{2}));
            acc_1nn=mean(labels(iii(1,:))==test_labels);%1NN
            acc_knn=mean(mode(labels(iii(1:knn,:)))'==test_labels); %knn
            arez=cat(2,arez,[acc_1nn acc_knn]);
            unit_weights{mmm,qii}=w;
        end%end-Q 
        new_results(mmm,:)=arez;
    end % end-Monte Carlo
    % Output results
    M=[orig_results,new_results];
    rez=mean(M);
    rez2=std(M);
    method_str=cell(size(M,2),1);
    method_str(1:2)={'Orig. 1NN','Orig. kNN'};%,'CAML 3NN','CAML SVM'};
    for ii=1:numel(Qs)
        if Qs(ii)==1
            postfix='';
        else
            postfix=sprintf(' Q=%i',Qs(ii));
        end
        if run_approx(ii)==1
            prefix='~';
        else
            prefix='';
        end
        method_str{3+2*(ii-1)}=[prefix,'CAML 1NN',postfix];
        method_str{4+2*(ii-1)}=[prefix,'CAML kVM',postfix];
    end    
    fprintf('%s\n Accuracy (%c correct)\n',dataset{1},'%');
    for ii=1:numel(method_str)
        fprintf('%s:%s%i±%.1f\n',method_str{ii},[char(9),char(9)],round(rez(ii)*100),100*rez2(ii));
    end
end
