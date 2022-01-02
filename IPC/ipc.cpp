#include<pthread.h>
#include<semaphore.h>
#include<queue>
#include <unistd.h>
#include <ctime>
#include<bits/stdc++.h>
using namespace std;

int n,kiosks,belts,per_belt,kiosk_time,security_time,boarding_time,vip_time;

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
	 if(p->is_vip())
	 cout<<"Passenger "<<i+1<<"(VIP) has arrived at the airport at time "<<end-start+1<<endl;
	else
		cout<<"Passenger "<<i+1<<" has arrived at the airport at time "<<end-start+1<<endl;
}
int main(int argc,char *argv[]){

	srand(time(0));
	ifstream file;
  	file.open(argv[1]);
	file>>kiosks>>belts>>per_belt;
	file>>kiosk_time>>security_time>>boarding_time>>vip_time;
	//cout<<kiosks<<endl<<belts<<endl<<per_belt;
	passengers=new passenger*[n];
	//n=100;
	int i=0;
	n=1000;
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
