#include<iostream>
#include<vector>
using namespace std;

void computeNext(string pattern, vector<int>& next){
	int len=pattern.size();
	next.push_back(0);
	int matchLength=0;
	for(int q=1; q<len; q++){
		while(matchLength>0 && pattern[q]!=pattern[matchLength]){
			matchLength=next[matchLength-1];
		}
		if(pattern[q]==pattern[matchLength]){
			matchLength++;
		}
		next.push_back(matchLength);
	}
}

int kmp(string str, string pattern){
	vector<int> next;
	computeNext(pattern, next);
	int m=str.size();
	int n=pattern.size();
	for(int i=0, matchLength=0; i<m; i++){
		while(matchLength>0 && str[i]!=pattern[matchLength]){
			matchLength=next[matchLength-1];
		}
		if(str[i]==pattern[matchLength]){
			matchLength++;
		}
		if(matchLength==n)
			return i-n+1;
	}
	return -1;
}

int main(){
	string str="BBC ABCDAB ABCDABCDABDE";
	string pattern="ABCDABD";
	cout<<kmp(str, pattern)<<endl;
	return 0;
}