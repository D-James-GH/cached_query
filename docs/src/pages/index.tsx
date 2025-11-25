import React from "react";
import clsx from "clsx";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import HomepageFeatures from "@site/src/components/HomepageFeatures";
import CodeBlock from "@theme/CodeBlock";

import styles from "./index.module.css";

function HomepageHeader() {
    const { siteConfig } = useDocusaurusContext();
    const codeExample = `
Query<User> userQuery(String userId) {
  return Query<User>(
    key: 'user_data?id=$userId',
    queryFn: () => fetchUserData(userId),
  );
}

userQuery("12").stream.listen((state){});
`;
    const flutterExample = `
class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return QueryBuilder(
      query: userQuery("12"),
      builder: (context, state) {
        return switch (state) {
          QueryLoading<User>() ||
          QueryInitial<User>() =>
            const CircularProgressIndicator(),
          QueryError<User>(:final error) => Text('Error: \$error'),
          QuerySuccess<User>(:final data) => Text('User: \${data.name}'),
        };
      },
    );
  }
}
`;

    return (
        <header className={clsx("hero hero--primary", styles.heroBanner)}>
            <div className="container">
                <div className={styles.heroContent}>
                    <div className={styles.heroLeft}>
                        <div className={styles.titleContainer}>
                            <img
                                src="/img/logo.svg"
                                alt="Cached Query Logo"
                                className={styles.logo}
                            />
                            <h1 className={styles.heroTitle}>{siteConfig.title}</h1>
                        </div>
                        <p className="hero__subtitle">{siteConfig.tagline}</p>
                        <div className={styles.buttons}>
                            <Link className="button button--primary button--lg" to="/docs/overview">
                                Get started
                            </Link>
                        </div>
                    </div>
                    <div className={styles.heroRight}>
                        <h3>Use in dart:</h3>
                        <CodeBlock language="dart">{codeExample}</CodeBlock>
                        <h3>To use in Flutter UI:</h3>
                        <CodeBlock language="dart">{flutterExample}</CodeBlock>
                    </div>
                </div>
            </div>
        </header>
    );
}

export default function Home(): JSX.Element {
    const { siteConfig } = useDocusaurusContext();
    return (
        <Layout
            title={siteConfig.title}
            description="Description will go into a meta tag in <head />"
        >
            <HomepageHeader />
            <main>
                <HomepageFeatures />
            </main>
        </Layout>
    );
}
