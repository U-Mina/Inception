void PmergeMe::callVectSort(char** av)
{	
	this->takeIputVec(av);
	if (this->vector.size() == 1) {
		this->bigChain_v.push_back(this->vector.at(0));
	}
	else {
		this->makeVecPair();
		this->sortVecPair();
		this->splitVecSort(this->vecPair, 0, this->vecPair.size() - 1);
		this->makeVecChain();
		this->insertion_v();
	}
	
}

void PmergeMe::takeIputVec(char** av)
{
	int i;
	int val;
	i = 1;
	while (av[i]) {
		if (av[i][0] == '\0') {
			throw std::invalid_argument("empty integer input!\n");
		}
		val = std::atoi(av[i]);
		if (val < 0) {
			throw std::invalid_argument("Error\ninput must be non-negative");
		}
		this->vector.push_back(val);
		i++;
	}
}

void PmergeMe::makeVecPair()
{
	size_t size;
	int i;

	i = 0;
	size = this->vector.size() / 2;
	while (size != 0)
	{
		this->vecPair.push_back(std::make_pair(this->vector.at(i), this->vector.at(i + 1)));
		i += 2;
		size--;
	}
}

void PmergeMe::sortVecPair()
{
	size_t i;
	int tmp;

	i = 0;
	while (i < this->vecPair.size()) {
		if (this->vecPair.at(i).first < this->vecPair.at(i).second) {
			tmp = this->vecPair.at(i).first;
			this->vecPair.at(i).first = this->vecPair.at(i).second;
			this->vecPair.at(i).second = tmp;
		}
		i++;
	}
}

void PmergeMe::splitVecSort(std::vector<std::pair<int, int>>& arr, int st, int ed)
{
	if (st >= ed) {
		return ;
	}
	int mid = st + (ed - st) / 2;
	this->splitVecSort(arr, st, mid);
	this->splitVecSort(arr, mid + 1, ed);
	this->mergeVec(arr, st, mid, ed);
}

void PmergeMe::mergeVec(std::vector<std::pair<int, int>>& arr, int st, int mid, int ed)
{
	size_t l_idx;
	size_t r_idx;
	size_t i;

	std::vector<std::pair<int, int>> l_Part(arr.begin() + st, arr.begin() + mid + 1);
	std::vector<std::pair<int ,int>> r_Part(arr.begin() + mid + 1, arr.begin() + ed + 1);

	l_idx = 0;
	r_idx = 0;
	i = st;

	while (l_idx < l_Part.size() && r_idx < r_Part.size()) {
		if (l_Part[l_idx].first <= r_Part[r_idx].first) {
			arr[i] = l_Part[l_idx];
			l_idx++;
		} else {
			arr[i] = r_Part[r_idx];
			r_idx++;
		}
		i++;
	}
	while (l_idx < l_Part.size()) {
		arr[i] = l_Part[l_idx];
		l_idx++;
		i++;
	}
	while (r_idx < r_Part.size()) {
		arr[i] = r_Part[r_idx];
		r_idx++;
		i++;
	}
}

void PmergeMe::makeVecChain()
{
	size_t i;
	bigChain_v.push_back(this->vecPair.at(0).second);
	i = 0;
	while (i < this->vecPair.size()) {
		bigChain_v.push_back(this->vecPair.at(i).first);
		smallChain_v.push_back(this->vecPair.at(i).second);
		i++;
	}
}

int PmergeMe::binSrchVec(std::vector<int> arr, int target, int st, int ed)
{
	int mid;

	while (st <= ed)
	{
		mid = st + (ed - st) / 2;
		if (target == arr.at(mid)) {
			return mid;
		}
		if (target > arr.at(mid))
		{
			st = mid + 1;
		} else {
			ed = mid - 1;
		}
	}
	if (target > arr.at(mid)) {
		return mid + 1;
	} else
	{
		return mid;
	}
}

int PmergeMe::calcuJknbr(int size)
{
	if (size == 0) {
		return 0;
	}
	if (size == 1) {
		return 1;
	}
	return (calcuJknbr(size - 1) + 2 * calcuJknbr(size - 2));
}

void PmergeMe::createJkOrder()
{
	size_t size;
	size_t jkIdx;
	int i;
	size = this->smallChain_v.size();
	i = 3;
	while ((jkIdx = this->calcuJknbr(i)) < size - 1) {
		this->jkOrder.push_back(jkIdx);
		i++;
	}
}

void PmergeMe::createInsrtOrder()
{
	if (this->smallChain_v.empty() == true) {
		return ;
	}
	this->createJkOrder();
	size_t pre_jkIdx = 1;
	size_t cur_jkIdx = 1; 
	size_t jkOrderIdx = 0;

	while (jkOrderIdx < this->jkOrder.size())
	{
		cur_jkIdx = jkOrder.at(jkOrderIdx); 
		this->insrtPos_v.push_back(cur_jkIdx);
		
		size_t backtrackIdx = cur_jkIdx - 1;
		while (backtrackIdx > pre_jkIdx) {
			this->insrtPos_v.push_back(backtrackIdx);
			backtrackIdx--;
		}
		pre_jkIdx = cur_jkIdx;
		jkOrderIdx++;
	}
	while (cur_jkIdx++ < this->smallChain_v.size()) {
		this->insrtPos_v.push_back(cur_jkIdx);
	}
}

void PmergeMe::insertion_v()
{
	int target;
	size_t curPos;
	this->createInsrtOrder();
	size_t added = 0;
	std::vector<int>::iterator it;
	for (it = this->insrtPos_v.begin(); it != this->insrtPos_v.end(); ++it)
	{
		size_t endPos = added + *it;
		target = this->smallChain_v.at(*it - 1);
		curPos = this->binSrchVec(this->bigChain_v, target, 0, endPos);
		this->bigChain_v.insert(this->bigChain_v.begin() + curPos, target);
		added++;
	}
	if (this->vector.size() % 2 != 0)
	{
		target = this->vector.at(this->vector.size() - 1);
		curPos = this->binSrchVec(this->bigChain_v, target, 0, this->bigChain_v.size() - 1);
		this->bigChain_v.insert(this->bigChain_v.begin() + curPos, target);
	}
}