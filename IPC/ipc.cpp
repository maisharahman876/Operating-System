#include<pthread.h>
#include<semaphore.h>
#include<queue>
#include <unistd.h>
#include <ctime>
#include<bits/stdc++.h>
using namespace std;

int n,kiosks,belts,per_belt,kiosk_time,security_time,boarding_time,vip_time;
int vips,losts,vips2;
int kiosk_count=1;
sem_t *sem;
pthread_mutex_t *mtx_k;
pthread_mutex_t left_m;
pthread_mutex_t right_m;
pthread_mutex_t boarding;

std::default_random_engine generator;

std::poisson_distribution<int> distribution(3);

time_t start=time(&start);

class passenger
{
	bool vip,lost_ticket;
	int id;
	int time;
public:
	passenger(int);
	~passenger();
	void make_vip();
	void lose_ticket();
	void restart();
	bool is_vip();
	bool lost();

	
};
passenger::passenger(int id)
{
	this->id=id;
	vip=false;
	lost_ticket=false;
}
void passenger::make_vip()
{
	vip=true;
}
void passenger::lose_ticket()
{
	lost_ticket=true;
}
void passenger::restart()
{
	lost_ticket=false;
}
bool passenger::is_vip()
{
	return vip;
}
bool passenger::lost()
{
	return lost_ticket;
}

passenger** passengers;

void * airport(void * arg)
{
	 int *param = (int *)arg;
	 int i=param[0];
	 passenger* p=passengers[i];
	 time_t end=time(&end);
	 string s="";
	 if(p->is_vip())
	 	s="(VIP)";

	 
	 cout<<"Passenger "<<i+1<<s<<" has arrived at the airport at time "<<end-start+1<<endl;
	
	//Kiosk enter


	int j=rand()%kiosks+1;
	
	pthread_mutex_lock(&mtx_k[j-1]);
	//sem_getvalue(&k,&j);
	end=time(&end);
	
	 cout<<"Passenger "<<i+1<<s<<" has started self-check in at kiosk "<<j<<" at time "<<end-start+1<<endl;
	
	
	sleep(kiosk_time);

	 end=time(&end);
	 
	cout<<"Passenger "<<i+1<<s<<" has finished check in at kiosk "<<j<<" at time "<<end-start+1<<endl;
	pthread_mutex_unlock(&mtx_k[j-1]);
	
	//pthread_mutex_unlock(&mtx);
	//sem_post(&k);

	if(s=="")
	{
		int b=rand()%belts+1;
		end=time(&end);
		cout<<"Passenger "<<i+1<<s<<" has started waiting for security check in belt "<<b<<" at time "<<end-start+1<<endl;
		sem_wait(&sem[b-1]);

		end=time(&end);
		cout<<"Passenger "<<i+1<<s<<" has started the security check in belt "<<b<<" at time "<<end-start+1<<endl;

		sleep(security_time);

		end=time(&end);
		cout<<"Passenger "<<i+1<<s<<" has crossed the security check in belt "<<b<<" at time "<<end-start+1<<endl;
		
		sem_post(&sem[b-1]);
	}
	else
	{
		end=time(&end);
		cout<<"Passenger "<<i+1<<s<<" has started waiting for VIP channel at time "<<end-start+1<<endl;
		vips2++;
		pthread_mutex_lock(&left_m);
		vips++;
		if(vips==1)
		{
			pthread_mutex_lock(&right_m);
		}
		pthread_mutex_unlock(&left_m);

		end=time(&end);
		cout<<"Passenger "<<i+1<<s<<" has started moving in VIP channel at time "<<end-start+1<<endl;

		sleep(vip_time);

		end=time(&end);
		cout<<"Passenger "<<i+1<<s<<" has crossed VIP channel at time "<<end-start+1<<endl;
		
		pthread_mutex_lock(&left_m);
		vips2--;
		vips--;
		if(vips==0)
		{
			pthread_mutex_unlock(&right_m);
		}
		pthread_mutex_unlock(&left_m);

	}

	//boarding
	
	if(i%5==3||i%7==4)
	{
	end=time(&end);
	cout<<"Passenger "<<i+1<<s<<" has started waiting to be boarded at time "<<end-start+1<<endl;

	pthread_mutex_lock(&boarding);
	cout<<"Passenger "<<i+1<<s<<" has lost his boarding pass."<<endl;
	pthread_mutex_unlock(&boarding);

	//
	end=time(&end);
	cout<<"Passenger "<<i+1<<s<<" has started waiting to the right side of VIP channel at time "<<end-start+1<<endl;

	pthread_mutex_lock(&right_m);
	losts++;
	if(losts==1)
		pthread_mutex_lock(&left_m);
	pthread_mutex_unlock(&right_m);

	end=time(&end);
	cout<<"Passenger "<<i+1<<s<<" has started moving in the opposite direction of VIP channel at time "<<end-start+1<<endl;

	sleep(vip_time);

	end=time(&end);
	cout<<"Passenger "<<i+1<<s<<" has crossed VIP channel on the opposite direction at time "<<end-start+1<<endl;

	pthread_mutex_lock(&right_m);
	losts--;
	if(vips2!=0)
	pthread_mutex_unlock(&left_m);
	pthread_mutex_unlock(&right_m);

	
		
	}
	else
	{
	end=time(&end);
	cout<<"Passenger "<<i+1<<s<<" has started waiting to be boarded at time "<<end-start+1<<endl;

	pthread_mutex_lock(&boarding);
	end=time(&end);
	cout<<"Passenger "<<i+1<<s<<" has started boarding the plane at time "<<end-start+1<<endl;


	sleep(boarding_time);

	end=time(&end);
	cout<<"Passenger "<<i+1<<s<<" has  boarded the plane at time "<<end-start+1<<endl;

	pthread_mutex_unlock(&boarding);

	}

}
int main(int argc,char *argv[]){

	srand(time(0));
	ifstream file;
  	file.open(argv[1]);
	file>>kiosks>>belts>>per_belt;
	file>>kiosk_time>>security_time>>boarding_time>>vip_time;
	freopen("output.txt", "w", stdout);

	mtx_k=new pthread_mutex_t[kiosks];
	sem=new sem_t[belts];
	pthread_mutex_init(&boarding,NULL);
	pthread_mutex_init(&left_m,NULL);
	pthread_mutex_init(&right_m,NULL);
	
	for(int m=0;m<kiosks;m++)
		pthread_mutex_init(&mtx_k[m],NULL);
	for(int m=0;m<belts;m++)
		sem_init(&sem[m],0,per_belt);

	//cout<<kiosks<<endl<<belts<<endl<<per_belt;
	passengers=new passenger*[n];
	//n=100;
	int i=0;
	n=1000;
	vips=0,losts=0,vips2=0;
	start=time(&start);
	//char* mi="meo";

	
	while(1)
	{
		int r=rand()%n;
		passenger* p=new passenger(i);
		passengers[i%n]=p;
		if(i%5==4||i%7==2||i%9==5||i%11==10)
			p->make_vip();
		time_t end=time(&end);
		int *param = (int *)malloc(1 * sizeof(int));
		param[0] = i;
		//cout<<"generated passenger "<<i<<" at "<<end-start<<endl;
		pthread_t thread;
		pthread_create(&thread,NULL,airport,param );
		int sleeptime=distribution(generator);
		sleep(sleeptime);
		i++;
	}
	
}
