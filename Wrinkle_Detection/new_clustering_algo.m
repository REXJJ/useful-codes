clear;
close all;
warning off;
global an;
m=csvread('/home/rex/Desktop/cluster_points.csv');
global m_o;
global ref;
global map ind;
map=zeros(1000,1000);
an=zeros(1000,1000);
ind=zeros(1000,1000);
for i=1:size(m,1)
    map(m(i,1),m(i,2))=1;
    an(m(i,1),m(i,2))=m(i,6);
    ind(m(i,1),m(i,2))=i;
end


   c=cluster(m);


function t=find_neighbor(i,j,A,l)
global map an ln;
checked=[i,j];
k=1;
t=[];
step=2;
while k<=size(checked,1)
    x=checked(k,1);
    y=checked(k,2);
    if map(x,y)==0
        k=k+1;
        continue;
    end
      t=[t;[x,y]];
        A=an(x,y);
        l=ln(x,y);

    k=k+1;
    map(x,y)=0;
for a=-step:step
    for b=-step:step
        if a==0&&b==0
            continue;
        end
        if x+a>900||y+b>900||x+a<1||y+b<1||map(x+a,y+b)==0||abs(an(x+a,y+b)-A)>20||abs(l-ln(x+a,y+b))/(l+ln(x+a,y+b))>0.20
        continue;
        end
        checked=[checked;[x+a,y+b]];
    end
end
end
end    



function id=find_unclassified(start,unclassified)
for i=start:size(unclassified,1)
    if unclassified(i)==1
        id=i;
        return;
    end
end
id=0;
end


function c=cluster(m)
global map m_o ref ind;
unclassified=ones(size(m,1),1);
class=zeros(size(m,1),1);
class_no=1;
start=1;
while 1
    it=find_unclassified(start,unclassified);
    start=it;
    if it==0
        break;
    end
    i=m(it,1);
    j=m(it,2);
    A=m(it,6);
    l=m(it,5);

    t=find_neighbor(i,j,A,l);
    points=0;
    ids=[];
    for i=1:size(t,1)
        id=ind(t(i,1),t(i,2));
        ids=[ids;id];
        unclassified(id)=0;
        points=points+1;
    end
        if points>50
          class(ids)=class_no;
          class_no=class_no+1;
        elseif points>10
          pt=transpose(t);
          if rank(t(2:end,:) - t(1,:)) ~= 1
          rt=minBoundingBox(pt);
          lenght=norm(rt(:,1)-rt(:,2));
          breadth=norm(rt(:,2)-rt(:,3));
          aspect_ratio=max(lenght,breadth)/min(lenght,breadth);
          if aspect_ratio>4
%               disp("Bounding box checking");
              class(ids)=class_no;
              class_no=class_no+1;
          end
          end
        end
%     if class_no==148
%         ref=t;
%             end

end
c=class;
end

% function cluster=get_cluster(c,id)
%     ids=find(c==id);
%     cluster=[m(id,1),m(id,2)]
% end
    



    
    