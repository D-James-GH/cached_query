import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Easy to Use',
    Svg: require('@site/static/img/undraw_home_run_re_rqli.svg').default,
    description: (
      <>
          Cached query has been designed to be minimal and easy to integrate into
          existing projects.
      </>
    ),
  },
  {
    title: 'Works with Bloc',
    Svg: require('@site/static/img/undraw_server_cluster_jwwq.svg').default,
    description: (
      <>
          Complements any architecture you may already be using.
      </>
    ),
  },
  {
    title: 'Improve UX',
    Svg: require('@site/static/img/undraw_my_app_re_gxtj.svg').default,
    description: (
      <>
          Easily improve the user experience of any flutter app by keeping data local,
          reducing the reliance of loading spinners
      </>
    ),
  },
];

function Feature({title, Svg, description}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
