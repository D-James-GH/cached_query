import React from "react";
import clsx from "clsx";
import Translate from "@docusaurus/Translate";
import Link from "@docusaurus/Link";
import { FaGithub } from "react-icons/fa";
import styles from "./styles.module.css";

const examples: Props[] = [
  {
    slug: "simple-query",
    name: "Simple Query Example",
    repo: "https://github.com/D-James-GH/cached_query/tree/main/examples/simple_caching",
    description:
      "The simplest and quickest way to get up and running with Cached Query.",
  },
  {
    slug: "with-flutter-bloc",
    name: "Simple Query with Flutter Bloc",
    repo: "https://github.com/D-James-GH/cached_query/tree/main/examples/simple_caching_with_bloc",
    description: "Caching with Flutter Bloc",
  },
  {
    slug: "infinite-query",
    name: "Infinite List",
    repo: "https://github.com/D-James-GH/cached_query/tree/main/examples/infinite_list",
    description: "Easily create an Infinite list with InfiniteQuery",
  },
  {
    slug: "infinite-list-with-bloc",
    name: "Infinite List with Bloc",
    repo: "https://github.com/D-James-GH/cached_query/tree/main/examples/infinite_list_with_bloc",
    description: "Create an Infinite list with flutter bloc and Infinite Query",
  },
];

interface Props {
  name: string;
  slug: string;
  repo: string;
  description: string;
}

function Example({ name, slug, description, repo }: Props) {
  return (
    <div className="col col--6 margin-bottom--lg">
      <div className={clsx("card")}>
        <div className="card__body">
          <h3>
            {name}
            <span className={styles.githubLink}>
              <a className={styles.githubIcon} href={repo}>
                <FaGithub />
              </a>
            </span>
          </h3>
          <p>{description}</p>
        </div>
        <div className="card__footer">
          <div className="button-group button-group--block">
            <Link className="button button--secondary" to={slug}>
              <Translate id="special.tryItButton">View Now!</Translate>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}

export function ExamplesRow(): JSX.Element {
  return (
    <div className="row">
      {examples.map((e) => (
        <Example key={e.name} {...e} />
      ))}
    </div>
  );
}
