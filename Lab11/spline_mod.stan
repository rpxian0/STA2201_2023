//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N; // number of years
  int<lower=0> S; // number of states
  matrix[N, S] y; // log entries per capita (year x state)
  int<lower=0> K;
  matrix[N, K] B; // data
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  matrix[K, S] alpha;
  vector<lower=0>[S] sigma_alpha;
  vector<lower=0>[S] sigma_y;

}

transformed parameters {
  matrix[N, S] mu;
  
  for (i in 1:N) {
    for (s in 1:S) {
      mu[i,s] = B[i,]*alpha[,s];
    }
  }
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  
  for  (s in 1:S) {
    y[,s] ~ normal(mu[,s], sigma_y[s]);
    alpha[1,s] ~ normal(0, sigma_alpha[s]);
    alpha[2,s] ~ normal(alpha[1,s], sigma_alpha[s]);
    alpha[3:K,s] ~ normal(2*alpha[2:(K-1), s] - alpha[1:(K-2), s], sigma_alpha[s]);
  }
  
  // Priors
  sigma_y ~ normal(0, 1);
  sigma_alpha ~ normal(0, 1);
}

