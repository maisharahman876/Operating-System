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
std::vector<passenger*> passengers;

int main(int argc,char *argv[]){

	srand(time(0));
	ifstream file;
  	file.open(argv[1]);
	file>>kiosks>>belts>>per_belt;
	file>>kiosk_time>>security_time>>boarding_time>>vip_time;
	//cout<<kiosks<<endl<<belts<<endl<<per_belt;
	//n=100;
	int i=0;
	start=time(&start);
	while(1)
	{
		passenger* p=new passenger(i);
		passengers.push_back(p);
		time_t end=time(&end);
		cout<<"generated passenger "<<i<<" at "<<end-start<<endl;
		int sleeptime=distribution(generator);
		sleep(sleeptime);
		i++;
	}
	
}
