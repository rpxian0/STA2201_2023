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
  int<lower=0> N; // number of regions
  int y[N]; // deaths
  vector[N] log_e; // log of expected deaths
  vector[N] x; // proportin of outside workers
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector[N] alpha;
  real beta;
}

transformed parameters {
  vector[N] log_theta;
  log_theta = alpha + beta*x;
}

model {
  y ~ poisson_log(log_theta+log_e);
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
}

